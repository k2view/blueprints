<!-- BEGIN_TF_DOCS -->


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
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name for resources name. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br>  "env": "dev",<br>  "owner": "owner",<br>  "project": "dev",<br>  "terraform": "true"<br>}</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain for rout53. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_arn"></a> [cert\_arn](#output\_cert\_arn) | ACM certificate ARN. |
| <a name="output_hz_zone_id"></a> [hz\_zone\_id](#output\_hz\_zone\_id) | Route 53 hosted zone ID. |
<!-- END_TF_DOCS -->