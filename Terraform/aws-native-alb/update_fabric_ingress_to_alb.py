#!/usr/bin/env python3
import argparse
import re
import sys
import time
from typing import Dict, Any, List, Tuple

from kubernetes import client, config
from kubernetes.client.rest import ApiException


NGINX_ANNOTATION_PREFIXES = (
    "nginx.ingress.kubernetes.io/",
)

ACM_ARN_RE = re.compile(
    r"^arn:(aws|aws-cn|aws-us-gov):acm:[a-z0-9-]+:\d{12}:certificate/[0-9a-f-]+$",
    re.IGNORECASE,
)


def _strip_nginx_annotations(annotations: Dict[str, str]) -> Tuple[Dict[str, str], List[str]]:
    cleaned: Dict[str, str] = {}
    removed: List[str] = []
    for k, v in annotations.items():
        if k.startswith(NGINX_ANNOTATION_PREFIXES):
            removed.append(k)
            continue
        cleaned[k] = v
    return cleaned, removed


def _validate_certificate_arn(value: str) -> None:
    if not value:
        return
    if not ACM_ARN_RE.match(value):
        raise ValueError(
            "certificate ARN does not look like ACM. Expected format: "
            "arn:aws:acm:<region>:<account>:certificate/<uuid>"
        )


def build_patch(existing: client.V1Ingress, args: argparse.Namespace) -> Dict[str, Any]:
    metadata = existing.metadata or client.V1ObjectMeta()
    annotations = dict(metadata.annotations or {})

    annotations, removed = _strip_nginx_annotations(annotations)

    # Prefer spec.ingressClassName; keep annotation for older controllers if present.
    annotations.setdefault("kubernetes.io/ingress.class", "alb")
    annotations["alb.ingress.kubernetes.io/scheme"] = args.scheme
    annotations["alb.ingress.kubernetes.io/target-type"] = args.target_type
    annotations["alb.ingress.kubernetes.io/listen-ports"] = args.listen_ports
    annotations["alb.ingress.kubernetes.io/ssl-redirect"] = str(args.ssl_redirect)
    annotations["alb.ingress.kubernetes.io/group.name"] = args.group_name
    annotations["alb.ingress.kubernetes.io/ssl-policy"] = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
    if args.certificate_arn:
        annotations["alb.ingress.kubernetes.io/certificate-arn"] = args.certificate_arn
    else:
        annotations.pop("alb.ingress.kubernetes.io/certificate-arn", None)

    # Explicitly remove nginx annotations in a merge patch by setting them to null.
    for key in removed:
        annotations[key] = None

    patch = {
        "metadata": {"annotations": annotations},
        "spec": {"ingressClassName": "alb"},
    }
    return patch


def wait_for_alb(
    api: client.NetworkingV1Api,
    namespace: str,
    name: str,
    timeout_seconds: int,
    interval_seconds: int,
) -> None:
    deadline = time.time() + timeout_seconds
    while time.time() < deadline:
        ing = api.read_namespaced_ingress(name=name, namespace=namespace)
        lb = ing.status.load_balancer if ing.status else None
        ingress_list: List[client.V1LoadBalancerIngress] = lb.ingress if lb else None
        if ingress_list:
            hostname = ingress_list[0].hostname
            if hostname:
                print(f"ALB ready for {namespace}/{name}: {hostname}")
                return
        time.sleep(interval_seconds)
    print(f"Timed out waiting for ALB for {namespace}/{name}", file=sys.stderr)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Set ingressClassName=alb for all Ingresses named fabric-ingress across all namespaces."
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print intended changes without applying them",
    )
    parser.add_argument(
        "--certificate-arn",
        help="ACM certificate ARN to attach to ALB (optional)",
        default="",
    )
    parser.add_argument(
        "--group-name",
        default="fabric",
        help="ALB group.name annotation value",
    )
    parser.add_argument(
        "--scheme",
        default="internet-facing",
        choices=["internet-facing", "internal"],
        help="ALB scheme",
    )
    parser.add_argument(
        "--target-type",
        default="ip",
        choices=["ip", "instance"],
        help="ALB target type",
    )
    parser.add_argument(
        "--listen-ports",
        default='[{"HTTP":80},{"HTTPS":443}]',
        help="ALB listen ports JSON",
    )
    parser.add_argument(
        "--ssl-redirect",
        default=443,
        type=int,
        help="HTTPS redirect port",
    )
    parser.add_argument(
        "--wait",
        action="store_true",
        help="Wait for ALB to be provisioned per ingress",
    )
    parser.add_argument(
        "--wait-timeout",
        type=int,
        default=600,
        help="Wait timeout in seconds per ingress",
    )
    parser.add_argument(
        "--wait-interval",
        type=int,
        default=15,
        help="Wait poll interval in seconds",
    )
    args = parser.parse_args()

    try:
        _validate_certificate_arn(args.certificate_arn)
    except ValueError as exc:
        print(f"Invalid --certificate-arn: {exc}", file=sys.stderr)
        return 2

    try:
        config.load_kube_config()
    except Exception:
        # Fall back to in-cluster config if kubeconfig isn't available
        config.load_incluster_config()

    api = client.NetworkingV1Api()

    try:
        ingresses = api.list_ingress_for_all_namespaces().items
    except ApiException as exc:
        print(f"Failed to list ingresses: {exc}", file=sys.stderr)
        return 1

    targets = [i for i in ingresses if (i.metadata and i.metadata.name == "fabric-ingress")]

    if not targets:
        print("No Ingress named fabric-ingress found.")
        return 0

    for ing in targets:
        ns = ing.metadata.namespace
        name = ing.metadata.name
        patch = build_patch(ing, args)

        if args.dry_run:
            print(f"[dry-run] {ns}/{name} -> ingressClassName=alb")
            continue

        try:
            api.patch_namespaced_ingress(name=name, namespace=ns, body=patch)
            print(f"Updated {ns}/{name}")
            if args.wait:
                wait_for_alb(api, ns, name, args.wait_timeout, args.wait_interval)
        except ApiException as exc:
            print(f"Failed to update {ns}/{name}: {exc}", file=sys.stderr)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

