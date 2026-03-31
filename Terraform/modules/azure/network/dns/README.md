# Azure DNS Module
Creates an Azure public DNS zone and two A records: a wildcard record (`*`) and a root record (`@`), both pointing to the same IP.

## Usage
```hcl
module "dns" {
  source = "./modules/azure/network/dns"

  resource_group_name = "my-resource-group"
  domain              = "example.com"
  record_ip           = "1.2.3.4"
  tags = {
    Env   = "prod"
    Owner = "k2view"
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
| [azurerm_dns_zone.dns_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_dns_a_record.nginx_dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.nginx_root_dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| domain | Domain name for the public DNS zone | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map` | n/a | yes |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| create_resource_group | Whether to create the resource group (set to false to use an existing one) | `bool` | `false` | no |
| record_ip | IP address for the DNS A records | `string` | `"1.1.1.1"` | no |
| dns_record_name | Name of the DNS A record (use * for wildcard) | `string` | `"*"` | no |

## Outputs
| Name | Description |
|------|-------------|
| dns_name_servers | Name servers associated with the DNS zone (delegate these at your registrar) |
