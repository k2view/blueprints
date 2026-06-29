# Traefik Ingress Controller Helm Chart

This chart packages the validated Traefik ingress controller configuration for
AKS, EKS, and GKE.

It is an umbrella chart over the upstream `traefik/traefik` chart, with small
K2view-owned templates for the wildcard TLS Secret, Traefik `TLSStore`, and the
custom error page for unknown spaces (see [Custom Error Page](#custom-error-page)).

## Install

Build dependencies once:

```bash
helm dependency build helm/traefik-ingress-controller
```

### Azure AKS

AKS uses the common LoadBalancer and Traefik-side TLS configuration.

```bash
kubectl create namespace traefik

kubectl create secret tls traefik-wildcard-tls \
  -n traefik \
  --cert=qa-migration/tls/azure/cert.pem \
  --key=qa-migration/tls/azure/key.pem

helm upgrade --install traefik helm/traefik-ingress-controller \
  --namespace traefik \
  --create-namespace \
  -f helm/traefik-ingress-controller/values.yaml \
  -f helm/traefik-ingress-controller/values-azure.yaml \
  --set domain=<space-parent-domain>
```

### Google GKE

GKE uses the common LoadBalancer, Traefik-side TLS, and the validated L4 RBS
Service annotation.

```bash
kubectl create namespace traefik

kubectl create secret tls traefik-wildcard-tls \
  -n traefik \
  --cert=qa-migration/tls/gcp/cert.pem \
  --key=qa-migration/tls/gcp/key.pem

helm upgrade --install traefik helm/traefik-ingress-controller \
  --namespace traefik \
  --create-namespace \
  -f helm/traefik-ingress-controller/values.yaml \
  -f helm/traefik-ingress-controller/values-gcp.yaml \
  --set domain=<space-parent-domain>
```

### AWS EKS

EKS uses ACM on an AWS Network Load Balancer for TLS termination. Do not add
`spec.tls` to application `Ingress` objects in this mode.

```bash
helm upgrade --install traefik helm/traefik-ingress-controller \
  --namespace traefik \
  --create-namespace \
  -f helm/traefik-ingress-controller/values.yaml \
  -f helm/traefik-ingress-controller/values-aws.yaml \
  --set domain=<space-parent-domain> \
  --set-string 'traefik.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-ssl-cert=arn:aws:acm:REGION:ACCOUNT_ID:certificate/CERT_ID'
```

## Optional Helm-Managed TLS Secret

For AKS/GKE, the default is to create the TLS Secret outside Helm. To let Helm
manage the Secret, pass certificate values through a secure values mechanism:

```bash
helm upgrade --install traefik helm/traefik-ingress-controller \
  --namespace traefik \
  --create-namespace \
  -f helm/traefik-ingress-controller/values.yaml \
  -f helm/traefik-ingress-controller/values-gcp.yaml \
  --set tls.create=true \
  --set-file tls.crt=qa-migration/tls/gcp/cert.pem \
  --set-file tls.key=qa-migration/tls/gcp/key.pem
```

## Custom Error Page

When a user hits a host that has no matching Ingress/route (e.g. a deleted or
non-existent space), Traefik serves a custom error page instead of its default
`404 page not found`. It provides a single catch-all response for unmatched
hosts at the Traefik layer.

How it works:

- A small `traefik-errors` `nginx:alpine` Deployment + Service proxies to a
  CloudFront-hosted page.
- A Traefik `IngressRoute` with `match: HostRegexp(\`^.+\.<domain>$\`)` and the
  **lowest priority (`1`)** acts as the catch-all. Real space routers have a
  higher (length-based) priority, so they always win for their own host+path;
  only unmatched hosts/paths fall through to the error page.
- The error pod runs with `automountServiceAccountToken: false`, so a compromise
  of this internet-facing workload yields no Kubernetes API credentials.

Enabled by default (`errorPage.enabled=true`). **You must set `domain` to the
parent domain under which spaces live** — the catch-all only matches
`*.<domain>`. For example, with `--set domain=devops.cloud-dev.k2view.com` the
route matches any `<anything>.devops.cloud-dev.k2view.com` that has no real
route. The default `domain` in `values.yaml` is a placeholder and will not match
real clusters.

On AKS/GKE the route is served on the `websecure` entryPoint with the default
`TLSStore` wildcard certificate. On AWS EKS (TLS terminated at the NLB) the
`values-aws.yaml` overlay serves it on the `web` entryPoint without Traefik-side
TLS. Override via `errorPage.entryPoints` and `errorPage.tls.enabled` if needed.

Verify (no extra DNS needed — fake the Host header against the LB IP):

```bash
# Unknown host -> custom error page
curl -kv -H "Host: nonexistent.<domain>" https://<LB_IP>/
```

To disable: `--set errorPage.enabled=false`.

## Configuration

The most commonly set values are listed below. See `values.yaml` for the full
set and `values.schema.json` for the validation rules. Provider-specific Service
annotations and TLS handling live in the `values-aws.yaml`, `values-azure.yaml`,
and `values-gcp.yaml` overlays, and the `traefik:` block is passed through to
the upstream `traefik/traefik` subchart.

| Value | Default | Description |
|-------|---------|-------------|
| `domain` | `site.cloud.k2view.com` (placeholder) | Parent domain under which spaces live. The catch-all error-page route only matches `*.<domain>`, so set this to the real cluster parent domain. |
| `errorPage.enabled` | `true` | Enable the catch-all custom error page for unmatched hosts. |
| `errorPage.cloudfrontUrl` | CloudFront 404 page URL | Page the error pod proxies to. |
| `errorPage.entryPoints` | `[websecure]` | Traefik entryPoint(s) the catch-all route listens on (`[web]` on AWS, where TLS terminates at the NLB). |
| `errorPage.tls.enabled` | `true` | Serve the catch-all route over TLS using the default `TLSStore` certificate (`false` on AWS). |
| `tls.secretName` | `traefik-wildcard-tls` | Name of the wildcard TLS Secret used by the `TLSStore`. |
| `tls.create` | `false` | When `true`, Helm creates the TLS Secret from `tls.crt`/`tls.key`; otherwise create it outside Helm. |
| `tlsStore.enabled` | `true` | Create a Traefik `TLSStore` using the wildcard certificate as the default (disabled on AWS, where the NLB terminates TLS). |
| `global.internalLoadBalancer.enabled` | `false` | Provision an internal/private cloud load balancer instead of an internet-facing one (see [Internal Load Balancer](#internal-load-balancer)). |

## Internal Load Balancer

Set `global.internalLoadBalancer.enabled=true` to make the provider overlay
create an internal/private cloud load balancer instead of the default
internet-facing one.

> **Disclaimer:** this is an edge case. With an internal load balancer the
> controller is not reachable from the public internet, so establishing
> connectivity to the cluster (VPN, network peering, bastion, private DNS, etc.)
> is **the user's responsibility** and is out of scope for this chart.

## Verify

```bash
helm -n traefik status traefik
kubectl -n traefik get pods,svc
kubectl get ingressclass traefik
```
