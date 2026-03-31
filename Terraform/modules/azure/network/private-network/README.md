# Azure Private Network Module
Creates a full private network stack for an AKS cluster: VNet, subnet, NAT gateway, and optional route table. Set `create_network = false` to skip VNet/subnet creation and reuse an existing subnet instead.

## Usage
```hcl
module "network" {
  source = "./modules/azure/network/private-network"

  prefix_name                   = "myCluster"
  resource_group_name           = "my-resource-group"
  location                      = "West Europe"
  virtual_network_address_space = "10.0.0.0/8"
  subnet_address_prefixes       = "10.240.0.0/16"
  create_nat_gateway            = true
}
```

### Using an existing subnet
```hcl
module "network" {
  source = "./modules/azure/network/private-network"

  prefix_name         = "myCluster"
  resource_group_name = "my-resource-group"
  create_network      = false
  subnet_id           = "/subscriptions/.../subnets/my-subnet"
  create_nat_gateway  = true
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
| [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_public_ip.aks_nat_gateway_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_nat_gateway.aks_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.aks_nat_gateway_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_subnet_nat_gateway_association.aks_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route.outbound_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_subnet_route_table_association.subnet_route_table_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix_name | Prefix applied to all network resource names | `string` | n/a | yes |
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| create_network | Whether to create a new VNet and subnet (set to false to use an existing one) | `bool` | `true` | no |
| virtual_network_address_space | VNet address space in CIDR notation | `string` | `"10.0.0.0/8"` | no |
| subnet_address_prefixes | Subnet address space in CIDR notation | `string` | `"10.240.0.0/16"` | no |
| subnet_id | Existing subnet ID to use when create_network is false | `string` | `""` | no |
| public_ip | Whether to create a public IP for the NAT gateway | `bool` | `true` | no |
| create_nat_gateway | Whether to create a NAT gateway for outbound traffic | `bool` | `true` | no |
| create_route_table | Whether to create a route table for user-defined routing | `bool` | `false` | no |
| route_table_address_prefix | Destination CIDR for the outbound route (e.g. 0.0.0.0/0) | `string` | `"0.0.0.0/0"` | no |
| route_table_next_hop_ip | Next hop IP for user-defined routing (required when create_route_table is true) | `string` | `""` | no |
| tags | Tags to apply to all resources | `map` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| aks_subnet_id | Resource ID of the AKS subnet (created or existing) |
| aks_network_name | Name of the AKS virtual network |
