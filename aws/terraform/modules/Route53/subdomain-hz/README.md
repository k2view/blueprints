## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |


## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_route53_record.cret_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.parent_hz_ns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.cluster_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.parent_hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name for resources name. | `any` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain for rout53. | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment for tag (Dev/QA/Prod). | `string` | `"Dev"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner name for tag. | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name for tag, if cluster name will be empty it will replace cluster name in the names. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_arn"></a> [cert\_arn](#output\_cert\_arn) | Certificate ARN |
| <a name="output_hz_zone_id"></a> [hz\_zone\_id](#output\_hz\_zone\_id) | n/a |
