# Azure Resource Group Module
Creates an Azure resource group. Set `create_resource_group = false` to skip creation and use an existing group instead.

## Usage
```hcl
module "resource_group" {
  source = "./modules/azure/resource-group"

  resource_group_name   = "my-resource-group"
  location              = "West Europe"
  create_resource_group = true
  tags = {
    Env     = "prod"
    Owner   = "k2view"
    Project = "my-project"
  }
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
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| create_resource_group | Whether to create the resource group (set to false to use an existing one) | `bool` | `true` | no |
| tags | Tags to apply to all resources | `map` | `{ Env = "Dev", Owner = "k2view", Project = "k2vDev" }` | no |

## Outputs
| Name | Description |
|------|-------------|
| resource-group-name | Name of the created resource group |
