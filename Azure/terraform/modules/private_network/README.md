# Private Network Module for AKS with NAT Gateway
This Terraform module is designed to create a private network environment for Azure Kubernetes Service (AKS), including a NAT gateway for secure, outbound connectivity.

## Usage
To use this module for setting up a private network for your AKS cluster, include the following configuration in your Terraform script:

```hcl
module "AKS_private_network" {
  source                        = "../modules/private_network"
  resource_group_name           = var.resource_group_name  # Azure Resource Group
  location                      = var.location  # Geographic location for deployment
  virtual_network_address_space = var.virtual_network_address_space  # VNet address space
  subnet_address_prefixes       = var.subnet_address_prefixes  # Subnet address prefixes
}
```

This configuration sets up a private network with specified address spaces and subnet configurations within your specified Azure Resource Group and location.

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources
| Name | Type |
|------|------|
| [azurerm_nat_gateway.aks_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.aks_nat_gateway_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_public_ip.aks_nat_gateway_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.aks_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure location for deploying resources | `string` | `"West Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Azure Resource Group | `string` | n/a | yes |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | Subnet address prefixes in CIDR notation | `string` | `"10.240.0.0/16"` | no |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Address space for the virtual network in CIDR notation | `string` | `"10.0.0.0/8"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_aks_subnet_id"></a> [aks\_subnet\_id](#output\_aks\_subnet\_id) | The ID of the AKS subnet created within the virtual network. |
