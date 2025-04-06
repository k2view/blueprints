<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.nat_reserved_private_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.nat_instance_firewall_traffic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.nat_gateway](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_route.nat_instance_route](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | `""` | no |
| <a name="input_dest_range"></a> [dest\_range](#input\_dest\_range) | Destination IP range | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the NAT instance | `string` | `"e2-medium"` | no |
| <a name="input_nat_instance_fw_ports"></a> [nat\_instance\_fw\_ports](#input\_nat\_instance\_fw\_ports) | Ports to open for a NAT instance | `list(string)` | <pre>[<br>  "5432"<br>]</pre> | no |
| <a name="input_nat_instance_ingress_gke"></a> [nat\_instance\_ingress\_gke](#input\_nat\_instance\_ingress\_gke) | CIDR ranges of GKE pods to allow ingress to NAT instance | `list(string)` | <pre>[<br>  "10.176.0.0/14"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Region for reserved IP | `string` | `""` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | The subnet to create the NAT instance in | `string` | `""` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC for the NAT instance | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_reserved_ip"></a> [nat\_reserved\_ip](#output\_nat\_reserved\_ip) | NAT instance reserved IP |
<!-- END_TF_DOCS -->