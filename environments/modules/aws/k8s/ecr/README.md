<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | terraform-aws-modules/ecr/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the ECR repository. | `string` | n/a | yes |
| <a name="input_repository_read_write_access_arns"></a> [repository\_read\_write\_access\_arns](#input\_repository\_read\_write\_access\_arns) | A list of IAM ARNs that will have read and write access to the ECR repository. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the ECR repository. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | The ARN of the ECR repository |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | The name of the ECR repository |
| <a name="output_repository_registry_id"></a> [repository\_registry\_id](#output\_repository\_registry\_id) | The registry ID of the ECR repository |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The URL of the ECR repository |
<!-- END_TF_DOCS -->