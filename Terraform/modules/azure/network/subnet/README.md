# Azure Subnet Module
Creates an Azure subnet within an existing VNet and associates it with a NAT gateway and optionally a route table.

## Usage
```hcl
module "subnet" {
  source = "./modules/azure/network/subnet"

  prefix_name             = "myCluster"
  resource_group_name     = "my-resource-group"
  vnet_name               = module.vnet.name
  subnet_address_prefixes = "10.240.0.0/16"
  nat_gateway_id          = module.vnet.nat_gateway_id
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
| [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.aks_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_route_table_association.subnet_route_table_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix_name | Prefix applied to all network resource names | `string` | n/a | yes |
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| vnet_name | Name of the virtual network to create the subnet in | `string` | n/a | yes |
| subnet_address_prefixes | Subnet address space in CIDR notation | `string` | `"10.240.0.0/16"` | no |
| nat_gateway_id | Resource ID of the NAT gateway to associate with the subnet | `string` | `""` | no |
| create_route_table | Whether to associate a route table with the subnet | `bool` | `false` | no |
| route_table_id | Resource ID of the route table to associate with the subnet | `string` | `""` | no |

## Outputs
| Name | Description |
|------|-------------|
| subnet_id | Resource ID of the created subnet |
