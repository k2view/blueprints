# Ingress-controller module
This module deploys an NGINX ingress controller onto a Kubernetes cluster using the official Helm chart. After the controller is ready, it waits for the LoadBalancer IP to be assigned and exposes it as an output. TLS can be configured via a certificate file path, plain-text string, or base64-encoded string.

## Usage
### AWS
```hcl
module "ingress_controller" {
  source              = "../modules/shared/ingress-controller"
  cloud_provider      = "AWS"
  domain              = var.domain
  aws_domain_cert_arn = var.aws_domain_cert_arn
  vpc_cidr            = var.vpc_cidr
}
```

### GCP / Azure
```hcl
module "ingress_controller" {
  source            = "../modules/shared/ingress-controller"
  cloud_provider    = "GCP"   # or "AZURE"
  domain            = var.domain
  tls_enabled       = true
  certb64String     = var.tls_cert_b64
  keyb64String      = var.tls_key_b64
  enable_private_lb = true
}
```

> **Note:** Only one TLS input method should be set at a time — either `*Path`, `*String`, or `*b64String`.

## Providers
| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Resources
| Name | Type |
|------|------|
| [helm_release.ingress-nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.nginx_controller_svc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain used for ingress routing (e.g. `example.com`). | `string` | n/a | yes |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider identifier (e.g. `aws`, `gcp`, `azure`). Passed to the Helm chart as the `provider` value. | `string` | `""` | no |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | When true, the Helm chart creates a TLS secret and configures HTTPS on the ingress controller. | `bool` | `true` | no |
| <a name="input_default_ssl_certificate"></a> [default\_ssl\_certificate](#input\_default\_ssl\_certificate) | When true, the ingress controller uses the provisioned TLS secret as the default SSL certificate for all ingress resources. | `bool` | `true` | no |
| <a name="input_keyPath"></a> [keyPath](#input\_keyPath) | Filesystem path to the TLS private key file. Mutually exclusive with `keyString`/`keyb64String`. | `string` | `""` | no |
| <a name="input_certPath"></a> [certPath](#input\_certPath) | Filesystem path to the TLS certificate file. Mutually exclusive with `certString`/`certb64String`. | `string` | `""` | no |
| <a name="input_keyString"></a> [keyString](#input\_keyString) | TLS private key as a plain-text string. Mutually exclusive with `keyPath`/`keyb64String`. | `string` | `""` | no |
| <a name="input_certString"></a> [certString](#input\_certString) | TLS certificate as a plain-text string. Mutually exclusive with `certPath`/`certb64String`. | `string` | `""` | no |
| <a name="input_keyb64String"></a> [keyb64String](#input\_keyb64String) | TLS private key encoded as a base64 string. Mutually exclusive with `keyPath`/`keyString`. | `string` | `""` | no |
| <a name="input_certb64String"></a> [certb64String](#input\_certb64String) | TLS certificate encoded as a base64 string. Mutually exclusive with `certPath`/`certString`. | `string` | `""` | no |
| <a name="input_enable_private_lb"></a> [enable\_private\_lb](#input\_enable\_private\_lb) | When true, the ingress controller LoadBalancer is created with a private (internal) IP instead of a public one. | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block for AWS NLB source-range whitelisting (`aws.vpc_cidr`). AWS only. | `string` | `""` | no |
| <a name="input_aws_domain_cert_arn"></a> [aws\_domain\_cert\_arn](#input\_aws\_domain\_cert\_arn) | ARN of the AWS ACM certificate to attach to the ingress controller LoadBalancer (`aws.awsDomainCert`). AWS only. | `string` | `""` | no |
| <a name="input_delay_command"></a> [delay\_command](#input\_delay\_command) | Shell command used to wait for the ingress controller LoadBalancer to become ready. Use `sleep 60` on Linux/macOS or `powershell -Command Start-Sleep -Seconds 60` on Windows. | `string` | `"sleep 60"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_nginx_lb_ip"></a> [nginx\_lb\_ip](#output\_nginx\_lb\_ip) | The IP address of the ingress controller LoadBalancer. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS hostname of the ingress controller LoadBalancer, if available (AWS). |
| <a name="output_ingress_test_url"></a> [ingress\_test\_url](#output\_ingress\_test\_url) | Test URL (`https://ingress-test.<domain>`) to validate the ingress controller is working. |
