# Azure Container Registry (ACR) Module
This module creates a new Azure Container Registry or references an existing one. It supports both creation and lookup modes via the `use_existing_acr` flag.

## Usage
### Create a new ACR
```hcl
module "acr" {
  source              = "../modules/acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
```

> **Note:** `acr_name` must use only lowercase letters. If omitted, a random suffix is used.

### Use an existing ACR
```hcl
module "acr" {
  source                      = "../modules/acr"
  use_existing_acr            = true
  existing_acr_name           = var.existing_acr_name
  existing_acr_resource_group = var.existing_acr_resource_group
}
```

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources
| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [random_string.acr_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_container_registry.existing_acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_admin_enabled"></a> [acr\_admin\_enabled](#input\_acr\_admin\_enabled) | Enable ACR admin user to push images. | `bool` | `true` | no |
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | The name of the ACR (only lowercase letters). If empty, a random suffix is used. | `string` | `""` | no |
| <a name="input_existing_acr_name"></a> [existing\_acr\_name](#input\_existing\_acr\_name) | The name of the existing ACR to use when `use_existing_acr` is true. | `string` | `null` | no |
| <a name="input_existing_acr_resource_group"></a> [existing\_acr\_resource\_group](#input\_existing\_acr\_resource\_group) | The resource group of the existing ACR. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure. | `string` | `"West Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name in Azure. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources. | `map` | `{}` | no |
| <a name="input_use_existing_acr"></a> [use\_existing\_acr](#input\_use\_existing\_acr) | If true, reference an existing ACR; if false, create a new one. | `bool` | `false` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The resource ID of the ACR. |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | The name of the ACR. |
