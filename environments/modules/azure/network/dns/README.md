# Azure DNS Zone Module
This Terraform module facilitates the creation of an Azure DNS zone and a corresponding A record that points to an ingress controller's load balancer. It simplifies the process of setting up domain name resolution for services deployed in Azure.

## Usage
To create a DNS zone and set up an A record in Azure using this module, include the following configuration in your Terraform script:
```hcl
module "DNS_zone" {
  source                  = "../modules/dns_zone"
  resource_group_name     = var.resource_group_name         # Azure Resource Group
  domain                  = var.domain                      # Domain for DNS zone
  record_ip               = module.AKS_ingress.nginx_lb_ip  # IP for DNS record
  tags                    = var.tags                        # Tags for resource identification
}
```

This configuration sets up a DNS zone for your specified domain and creates an A record with the IP address of your ingress controller's load balancer.

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |


## Resources
| Name | Type |
|------|------|
| [azurerm_dns_a_record.nginx_dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_zone.dns_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Create RG in Azure | `bool` | `false` | no |
| <a name="input_dns_record_name"></a> [dns\_record\_name](#input\_dns\_record\_name) | The DNS record name | `string` | `"*"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for DNS zone | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_record_ip"></a> [record\_ip](#input\_record\_ip) | The IP of the record to add | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_dns_name_servers"></a> [dns\_name\_servers](#output\_dns\_name\_servers) | "The name servers associated with the Azure DNS zone." |

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
| [azurerm_dns_a_record.nginx_dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.nginx_root_dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_zone.dns_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Create RG in Azure | `bool` | `false` | no |
| <a name="input_dns_record_name"></a> [dns\_record\_name](#input\_dns\_record\_name) | The DNS record name | `string` | `"*"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for DNS zone | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_record_ip"></a> [record\_ip](#input\_record\_ip) | The IP of the record to add | `string` | `"1.1.1.1"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name_servers"></a> [dns\_name\_servers](#output\_dns\_name\_servers) | The name servers associated with the Azure DNS zone. |
<!-- END_TF_DOCS -->