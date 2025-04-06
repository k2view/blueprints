<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ingress-nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.nginx_controller_svc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_domain_cert_arn"></a> [aws\_domain\_cert\_arn](#input\_aws\_domain\_cert\_arn) | The ARN of the AWS domain certificate. | `string` | `""` | no |
| <a name="input_certPath"></a> [certPath](#input\_certPath) | Path to the TLS cert file. | `string` | `""` | no |
| <a name="input_certString"></a> [certString](#input\_certString) | The TLS cert as a string. | `string` | `""` | no |
| <a name="input_certb64String"></a> [certb64String](#input\_certb64String) | The TLS cert string in base 64. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The name of the cloud provider. | `string` | `""` | no |
| <a name="input_default_ssl_certificate"></a> [default\_ssl\_certificate](#input\_default\_ssl\_certificate) | Flag to enable or disable default SSL certificate | `bool` | `true` | no |
| <a name="input_delay_command"></a> [delay\_command](#input\_delay\_command) | The command for delay, the cammand depend on the env the terraform runed on. | `string` | `"sleep 60"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | the domain will be used for ingress | `string` | n/a | yes |
| <a name="input_enable_private_lb"></a> [enable\_private\_lb](#input\_enable\_private\_lb) | Flag to enable or disable private load balancer IP | `bool` | `false` | no |
| <a name="input_keyPath"></a> [keyPath](#input\_keyPath) | Path to the TLS key file. | `string` | `""` | no |
| <a name="input_keyString"></a> [keyString](#input\_keyString) | The TLS key as a string. | `string` | `""` | no |
| <a name="input_keyb64String"></a> [keyb64String](#input\_keyb64String) | The TLS key string in base 64. | `string` | `""` | no |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | Flag to enable or disable TLS | `bool` | `true` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR range of the network | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_test_url"></a> [ingress\_test\_url](#output\_ingress\_test\_url) | The URL of the test ingress to validate successful deployment. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | n/a |
| <a name="output_nginx_lb_ip"></a> [nginx\_lb\_ip](#output\_nginx\_lb\_ip) | The IP address of the load balancer for the Nginx ingress controller. |
<!-- END_TF_DOCS -->