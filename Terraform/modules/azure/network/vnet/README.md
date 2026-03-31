# Azure VNet Module
Creates an Azure Virtual Network with an optional NAT gateway (for outbound internet access) and an optional route table (for user-defined routing via a virtual appliance).

## Usage
```hcl
module "vnet" {
  source = "./modules/azure/network/vnet"

  prefix_name                   = "myCluster"
  resource_group_name           = "my-resource-group"
  location                      = "West Europe"
  virtual_network_address_space = "10.0.0.0/8"
  create_nat_gateway            = true
  create_route_table            = false
}
```

## Requirements
| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Providers
| Name | Version |
|------|---------|
| [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) | >= 3.0 |

## Resources
| Name | Type |
|------|------|
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_public_ip.aks_nat_gateway_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_nat_gateway.aks_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.aks_nat_gateway_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route.outbound_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix_name | Prefix applied to all network resource names | `string` | n/a | yes |
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| virtual_network_address_space | VNet address space in CIDR notation | `string` | `"10.0.0.0/8"` | no |
| create_nat_gateway | Whether to create a NAT gateway for outbound traffic | `bool` | `true` | no |
| create_route_table | Whether to create a route table for user-defined routing | `bool` | `false` | no |
| route_table_address_prefix | Destination CIDR for the outbound route | `string` | `"0.0.0.0/0"` | no |
| route_table_next_hop_ip | Next hop IP for user-defined routing (required when create_route_table is true) | `string` | `""` | no |
| tags | Tags to apply to all resources | `map` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| name | Name of the virtual network |
| nat_gateway_id | Resource ID of the NAT gateway |
| route_table_id | Resource ID of the route table (empty string if not created) |
