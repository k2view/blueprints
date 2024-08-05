<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone_iam_member.cert_guardian_service_account_zone_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone_iam_member) | resource |
| [google_project_iam_binding.cert_guardian_service_account_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_custom_role.certguardian_custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_service_account.cert_guardian_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_managed_zone"></a> [managed\_zone](#input\_managed\_zone) | The DNS managed zone, if left empty the SA will have permessions over all DNS zones | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs. | `string` | `"k2view-dfaas"` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | The display name for the service account. | `string` | `"certguardian"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The service account ID. | `string` | `"certguardian"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | The email of the created service account. |
<!-- END_TF_DOCS -->