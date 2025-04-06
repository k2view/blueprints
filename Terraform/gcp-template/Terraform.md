## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-dns"></a> [cloud-dns](#module\_cloud-dns) | [../modules/gcp/network/dns](../modules/gcp/network/dns) | n/a |
| <a name="module_external-secret-operator"></a> [external-secret-operator](#module\_external-secret-operator) | [../modules/shared/external-secret-operator](../modules/shared/external-secret-operator) | n/a |
| <a name="module_gke"></a> [gke](#module\_gke) | [../modules/gcp/gke](../modules/gcp/gke) | n/a |
| <a name="module_iam-deployer-service-accounts"></a> [iam-deployer-service-accounts](#module\_iam-deployer-service-accounts) | [../modules/gcp/iam/deployer-service-accounts](../modules/gcp/iam/deployer-service-accounts) | n/a |
| <a name="module_ingress-controller"></a> [ingress-controller](#module\_ingress-controller) | [../modules/shared/ingress-controller](../modules/shared/ingress-controller) | n/a |
| <a name="module_k2view-agent"></a> [k2view-agent](#module\_k2view-agent) | [../modules/shared/k2view-agent](../modules/shared/k2view-agent) | n/a |
| <a name="module_nat-instance"></a> [nat-instance](#module\_nat-instance) | [../modules/gcp/nat-instance](../modules/gcp/nat-instance) | n/a |
| <a name="module_network-vpc"></a> [network-vpc](#module\_network-vpc) | [../modules/gcp/network/vpc](../modules/gcp/network/vpc) | n/a |
| <a name="module_secret-store-csi"></a> [secret-store-csi](#module\_secret-store-csi) | [../modules/shared/secret-store-csi](../modules/shared/secret-store-csi) | n/a |
| <a name="module_secret-store-csi-provider"></a> [secret-store-csi-provider](#module\_secret-store-csi-provider) | [../modules/gcp/secrets-store-csi-driver-provider-gcp](../modules/gcp/secrets-store-csi-driver-provider-gcp) | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.primary_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_dns_managed_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_compute_instance_template.instance_template](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_instance_group_manager.instance_group_manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager) | resource |
| [google_storage_bucket.storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_create_nat_instance"></a> [create\_nat\_instance](#input\_create\_nat\_instance) | A boolean flag to control whether to create NAT instance | `bool` | `false` | no |
| <a name="input_deploy_secret_store_csi"></a> [deploy\_secret\_store\_csi](#input\_deploy\_secret\_store_csi) | A boolean flag to control whether to deploy secret store csi | `bool` | `false` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for ingress | `string` | n/a | yes |
| <a name="input_gke_initial_worker_count"></a> [gke\_initial\_worker\_count](#input\_gke\_initial_worker_count) | The initial workers up | `number` | `2` | no |
| <a name="input_gke_kubernetes_version"></a> [gke\_kubernetes\_version](#input\_gke\_kubernetes\_version) | Kubernetes version of the GKE cluster | `string` | `"1.30"` | no |
| <a name="input_gke_max_worker_count"></a> [gke\_max\_worker\_count](#input\_gke_max_worker_count) | The maximum workers up | `number` | `3` | no |
| <a name="input_gke_min_worker_count"></a> [gke\_min\_worker_count](#input\_gke\_min_worker_count) | The minimum workers up | `number` | `1` | no |
| <a name="input_gke_worker_disk_size"></a> [gke\_worker_disk_size](#input\_gke_worker_disk_size) | The disk size for cluster workers | `number` | `500` | no |
| <a name="input_gke_worker_disk_type"></a> [gke\_worker_disk_type](#input\_gke_worker_disk_type) | The disk type for cluster workers | `string` | `"pd-standard"` | no |
| <a name="input_gke_worker_machine_type"></a> [gke\_worker_machine_type](#input\_gke_worker_machine_type) | The GCP VM type for cluster workers | `string` | `"e2-highmem-16"` | no |
| <a name="input_ingress_controller_cert_b64"></a> [ingress\_controller\_cert\_b64](#input\_ingress_controller_cert_b64) | Path to the TLS cert file. | `string` | `""` | no |
| <a name="input_ingress_controller_enable_private_lb"></a> [ingress\_controller\_enable_private_lb](#input\_ingress_controller_enable_private_lb) | Flag to enable or disable private load balancer IP | `bool` | `false` | no |
| <a name="input_ingress_controller_key_b64"></a> [ingress\_controller\_key\_b64](#input\_ingress_controller_key_b64) | Path to the TLS key file. | `string` | `""` | no |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view_agent_namespace) | The name of K2view agent namespace | `string` | `"k2view-agent"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox_id) | k2view cloud mailbox ID. | `string` | `""` | no |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox_url) | k2view cloud mailbox URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_nat_dest_ports"></a> [nat\_dest\_ports](#input\_nat_dest_ports) | NAT instance destination ports | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_nat_dest_range"></a> [nat\_dest\_range](#input\_nat_dest_range) | NAT instance destination IP range for routing | `string` | `""` | no |
| <a name="input_nat_instance_ingress"></a> [nat\_instance\_ingress](#input\_nat_instance_ingress) | CIDR ranges for NAT instance ingress | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project_id) | The project ID to host the network in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | A boolean flag to control whether GKE cluster is regional or zonal | `bool` | `true` | no |
| <a name="input_secondary_cidr_pods"></a> [secondary\_cidr\_pods](#input\_secondary_cidr_pods) | Secondary CIDR range for pods | `string` | `"10.176.0.0/14"` | no |
| <a name="input_secondary_cidr_services"></a> [secondary\_cidr\_services](#input\_secondary_cidr_services) | Secondary CIDR range for services | `string` | `"10.180.0.0/20"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones for GKE master and worker nodes | `list(string)` | <pre>[<br>  "a",<br>  "b"<br>]</pre> | no |
