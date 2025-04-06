<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-dns"></a> [cloud-dns](#module\_cloud-dns) | terraform-google-modules/cloud-dns/google | 5.3.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for ingress | `string` | n/a | yes |
| <a name="input_lb_ip"></a> [lb\_ip](#input\_lb\_ip) | IP of Load Balancer that point to this cluster. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The DNS Zone name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the network in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_dns"></a> [cloud\_dns](#output\_cloud\_dns) | The cloud DNS for the cluster created |
<!-- END_TF_DOCS -->