<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 31.1.0 |
| <a name="module_gke-service-account"></a> [gke-service-account](#module\_gke-service-account) | ../iam/gke-service-account | n/a |
| <a name="module_storage-class"></a> [storage-class](#module\_storage-class) | ../storage-class | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The disk size for cluster workers | `number` | `500` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for cluster workers | `string` | `"pd-standard"` | no |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | The initial workers up | `number` | `1` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version of the GKE cluster | `string` | `"1.28"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The GCP VM type for cluster workers | `string` | `"e2-highmem-4"` | no |
| <a name="input_max_node"></a> [max\_node](#input\_max\_node) | The maximum workers up | `number` | `3` | no |
| <a name="input_min_node"></a> [min\_node](#input\_min\_node) | The minimum workers up | `number` | `1` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the network in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | A boolean flag to control whether GKE cluster is regional or zonal | `bool` | `true` | no |
| <a name="input_storage_class_type"></a> [storage\_class\_type](#input\_storage\_class\_type) | The type of the storage class | `string` | `"pd-balanced"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the network | `string` | `""` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones for GKE master and worker nodes | `list(string)` | <pre>[<br>  "a",<br>  "b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | The email of the created service account. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The email of the created service account. |
<!-- END_TF_DOCS -->