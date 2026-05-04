# K2VIEW AWS Infrastructure Blueprint (ALB + external-dns example)

**Note:** This README is an example that demonstrates switching from the default NGINX-based ingress deployment to an AWS ALB + external-dns deployment. It is not a canonical or mandatory setup. Adjust it to your environment and standards.

## Base Instructions
For full Terraform build instructions, follow the default AWS template README:
`https://github.com/k2view/blueprints/blob/main/Terraform/aws-template/README.md`

This document only lists the changes and additions for ALB, external-dns, and K2view agent configuration.

## What Changes In This Example
- **Ingress**: Uses the AWS Load Balancer Controller (ALB) rather than the NGINX ingress controller.
- **DNS**: Uses external-dns with Route53 to create and update records (when `domain` is set), instead of relying on NGINX LB IP/hostname management.
- **Terraform Modules**: IAM and Helm installs for ALB and external-dns are done via the Terraform modules under `Terraform/modules/aws`.


## Supporting New Spaces With ALB (K2view Agent)
To build new spaces with ALB, update the `k2view-agent` deployment to set the `HELM_USER_VALUES_JSON` secret. The value must be the base64-encoded JSON below (adjust to your environment):
```json
{
  "fabric": {
    "ingress": {
      "enabled": true,
      "class_name": "alb",
      "type": "alb",
      "custom_annotations": {
        "enabled": true,
        "annotations": [
          {
            "key": "alb.ingress.kubernetes.io/scheme",
            "value": "internet-facing" 
          },
          {
            "key": "alb.ingress.kubernetes.io/target-type",
            "value": "ip"
          },
          {
            "key": "alb.ingress.kubernetes.io/group.name",
            "value": "fabric"
          },
          {
            "key": "alb.ingress.kubernetes.io/certificate-arn",
            "value": "arn:aws:acm:eu-central-1:XXXXXXX:certificate/aaaaaa-4987-4272-a26b-bbbbbbb"
          },
          {
            "key": "alb.ingress.kubernetes.io/ssl-redirect",
            "value": "443"
          },
          {
            "key": "alb.ingress.kubernetes.io/listen-ports",
            "value": "[{\"HTTP\":80},{\"HTTPS\":443}]"
          },
          {
            "key": "alb.ingress.kubernetes.io/ssl-policy",
            "value": "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
          },
          {
            "key": "alb.ingress.kubernetes.io/subnets", # optional
            "value": "subnet-aaaaaa, subnet-bbbb"
          }
        ]
      }
    }
  }
}
```

Reference: `helm/k2view-agent/README.md` (see `HELM_USER_VALUES_JSON`).


## References
- `https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html`
- `https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html`
- `https://kubernetes-sigs.github.io/external-dns/latest/docs/tutorials/aws/`
- `https://kubernetes-sigs.github.io/external-dns/latest/charts/external-dns/#values`
- `https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#using-helm-with-oidc`
