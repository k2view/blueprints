<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.deployer_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment.deployer_identity_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.deployer_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.space_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment.example_worker_blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.example_space_keyvault_secrets_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_resource_group.resource_group_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_principal_id"></a> [aks\_principal\_id](#input\_aks\_principal\_id) | Principal ID of the K8S cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the K8S cluster | `string` | n/a | yes |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view\_agent\_namespace) | K2view agent namespace name | `string` | `"k2view-agent"` | no |
| <a name="input_kubernetes_oidc_issuer_url"></a> [kubernetes\_oidc\_issuer\_url](#input\_kubernetes\_oidc\_issuer\_url) | K8S OIDC URL | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Virtual network subnet ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployer_identity_client_id"></a> [deployer\_identity\_client\_id](#output\_deployer\_identity\_client\_id) | Principal ID of the K8S cluster |
| <a name="output_deployer_identity_id"></a> [deployer\_identity\_id](#output\_deployer\_identity\_id) | The ID of the deployer identity |
| <a name="output_space_identity_client_id"></a> [space\_identity\_client\_id](#output\_space\_identity\_client\_id) | Principal ID of the K8S cluster |
<!-- END_TF_DOCS -->