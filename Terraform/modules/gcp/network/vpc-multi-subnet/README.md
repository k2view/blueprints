<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 5.3.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | 10.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.private_services_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_service_networking_connection.private_services_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_secondary_cidr_pods"></a> [dev\_secondary\_cidr\_pods](#input\_dev\_secondary\_cidr\_pods) | Secondary CIDR range for DEV GKE pods | `string` | `"10.176.0.0/18"` | no |
| <a name="input_dev_secondary_cidr_services"></a> [dev\_secondary\_cidr\_services](#input\_dev\_secondary\_cidr\_services) | Secondary CIDR range for DEV GKE services | `string` | `"10.176.64.0/20"` | no |
| <a name="input_dev_subnet_cidr"></a> [dev\_subnet\_cidr](#input\_dev\_subnet\_cidr) | Primary CIDR range for a DEV subnet | `string` | `"10.130.0.0/20"` | no |
| <a name="input_nat_subnet_cidr"></a> [nat\_subnet\_cidr](#input\_nat\_subnet\_cidr) | Primary CIDR range for a PROD subnet | `string` | `"10.130.0.0/20"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network | `string` | `""` | no |
| <a name="input_prod_secondary_cidr_pods"></a> [prod\_secondary\_cidr\_pods](#input\_prod\_secondary\_cidr\_pods) | Secondary CIDR range for PROD GKE pods | `string` | `"10.176.0.0/18"` | no |
| <a name="input_prod_secondary_cidr_services"></a> [prod\_secondary\_cidr\_services](#input\_prod\_secondary\_cidr\_services) | Secondary CIDR range for PROD GKE services | `string` | `"10.176.64.0/20"` | no |
| <a name="input_prod_subnet_cidr"></a> [prod\_subnet\_cidr](#input\_prod\_subnet\_cidr) | Primary CIDR range for a PROD subnet | `string` | `"10.130.0.0/20"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the network in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
| <a name="input_staging_secondary_cidr_pods"></a> [staging\_secondary\_cidr\_pods](#input\_staging\_secondary\_cidr\_pods) | Secondary CIDR range for STAGING GKE pods | `string` | `"10.176.0.0/18"` | no |
| <a name="input_staging_secondary_cidr_services"></a> [staging\_secondary\_cidr\_services](#input\_staging\_secondary\_cidr\_services) | Secondary CIDR range for STAGING GKE services | `string` | `"10.176.64.0/20"` | no |
| <a name="input_staging_subnet_cidr"></a> [staging\_subnet\_cidr](#input\_staging\_subnet\_cidr) | Primary CIDR range for a STAGING subnet | `string` | `"10.130.0.0/20"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
<!-- END_TF_DOCS -->