<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | list of the availability zones | `list(string)` | `[]` | no |
| <a name="input_database_subnet_tags"></a> [database\_subnet\_tags](#input\_database\_subnet\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2view-cloud"<br>}</pre> | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | list of the database subnets | `list(string)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | enable dns hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | enable dns support | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | enable nat gateway | `bool` | `true` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | enable vpn gateway | `bool` | `false` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2view-cloud"<br>}</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | list of the private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2view-cloud"<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | list of the public subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2view-cloud"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | vpc cidr | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | vpc name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | The database subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | The private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC |
<!-- END_TF_DOCS -->