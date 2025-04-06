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
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_role_assignment.role_acrpull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | The ID of the ACR to attach | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AKS name in Azure | `string` | n/a | yes |
| <a name="input_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#input\_kubeconfig\_file\_path) | Path for kubeconfig file | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. | `string` | `"1.30"` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum cluster size | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum cluster size | `number` | `1` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | Outbound Type | `string` | `"userAssignedNATGateway"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | hould this Kubernetes Cluster have its API server only exposed on internal IP addresses? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Virtual network subnet ID for existing Vnet | `string` | `""` | no |
| <a name="input_system_node_count"></a> [system\_node\_count](#input\_system\_node\_count) | Number of AKS worker nodes (min\_size <= system\_node\_count <= max\_size). | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2vDev"<br>}</pre> | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | VM sku | `string` | `"Standard_D8s_v3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | K8S Client Certificate for Providers |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | K8S Client Key for Providers |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | K8S Client CA Certificate for Providers |
| <a name="output_cluster_oidc_url"></a> [cluster\_oidc\_url](#output\_cluster\_oidc\_url) | K8S OIDC URL |
| <a name="output_host"></a> [host](#output\_host) | K8S Host for Providers |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Principal ID of the K8S cluster |
<!-- END_TF_DOCS -->