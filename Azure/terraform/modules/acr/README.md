# Azure Container Registry (ACR) Module for AKS Integration
This module facilitates the integration of Azure Container Registry (ACR) with Azure Kubernetes Service (AKS). It's designed to streamline the process of creating and configuring ACR to work seamlessly with AKS, enabling efficient management and deployment of containerized applications.

## Usage
To integrate ACR with your AKS, use the following Terraform configuration. This setup involves specifying parameters like the ACR name, the resource group it belongs to, and its location.

```hcl
module "create_acr" {
  source              = "../modules/acr"
  acr_name            = var.acr_name             # Name of your ACR
  resource_group_name = var.resource_group_name  # Azure Resource Group
  location            = var.location             # Geographic location
  tags                = var.tags                 # Tags for resource identification
  principal_id        = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity.0.object_id
}
```

>NOTE: acr_name should be unic and use only lowercase letters 

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources
| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_role_assignment.role_acrpull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_admin_enabled"></a> [acr\_admin\_enabled](#input\_acr\_admin\_enabled) | Enable ACR admin user to push images. | `bool` | `true` | no |
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | The name of ACR (only lowercase letters) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The kubelet identity id | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | "The admin password for the ACR." |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | "The name of the Azure Container Registry." |
