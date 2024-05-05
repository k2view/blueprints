# Private Network Module for AKS with NAT Gateway
This Terraform module is designed to create a private network environment for Azure Kubernetes Service (AKS), including a NAT gateway for secure, outbound connectivity.

## Usage
To use this module for setting up a private network for your AKS cluster, include the following configuration in your Terraform script:

```hcl
module "AKS_private_network" {
  source                        = "../modules/private_network"
  resource_group_name           = var.create_resource_group
  location                      = var.location
  prefix_name                   = var.cluster_name
  tags                          = var.tags
  subnet_address_prefixes       = var.subnet_address_prefixes
  create_network                = var.create_network
  subnet_id                     = var.subnet_id
  virtual_network_address_space = var.virtual_network_address_space
  create_nat_gateway            = var.create_nat_gateway
  create_route_table            = var.create_route_table
  route_table_next_hop_ip       = var.route_table_next_hop_ip
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
| [azurerm_route.outbound_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.aks_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_route_table_association.subnet_route_table_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Create NAT gateway. | `bool` | `true` | no |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Create Vnet for the AKS cluster | `bool` | `true` | no |
| <a name="input_create_route_table"></a> [create\_route\_table](#input\_create\_route\_table) | Create route table as a gateway. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_prefix_name"></a> [prefix\_name](#input\_prefix\_name) | Prefix for network names | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Create public IP for the NAT or no. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_route_table_address_prefix"></a> [route\_table\_address\_prefix](#input\_route\_table\_address\_prefix) | Route table address prefix. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_route_table_next_hop_ip"></a> [route\_table\_next\_hop\_ip](#input\_route\_table\_next\_hop\_ip) | IP address of the next hop in the routing table. | `string` | `""` | no |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | Virtual network subnet address prefixes CIDR | `string` | `"10.240.0.0/16"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Virtual network subnet ID for existing Vnet | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | `{}` | no |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Virtual network address space CIDR | `string` | `"10.0.0.0/8"` | no |


## Outputs
| Name | Description |
|------|-------------|
| <a name="output_aks_subnet_id"></a> [aks\_subnet\_id](#output\_aks\_subnet\_id) | The ID of the AKS subnet created within the virtual network. |
