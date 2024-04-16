#  K2view Site Deployment on Google Kubernetes Engine (GKE) using Terraform
This document describes how to create cloud manager site with private nodes, meaning traffic from all the nodes will come from a single IP address which could be whitelisted in security systems.

## Pre-requisites
1. Azure Account with Owner role in the relevant subscription.
2. Tarraform - [hashicorp install guide](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)
3. Google cloud cli - [gcloud install guide](https://cloud.google.com/sdk/docs/install)
4. Helm - [Helm install](https://helm.sh/docs/intro/install/)
5. Kubectl - [Kubectl install](https://kubernetes.io/docs/tasks/tools/)
6. Mailbox id - K2view cloud manager mailbox id.
7. Domain - subdomain that can be poinded to the clester (A record of *.site.domain.com will point to the load balancer IP). 
8. TLS wildcard certificate - wildcard certificate for the domain (privkey.pem and fullchain.pem of *.site.domain.com).


## Site Creation

### Clone the repository and configure the project
First clone the repository
```bash
git clone https://github.com/k2view/blueprints.git
cd blueprints/gcp/terraform/GKE
```

Copy [terraform.tfvars.template](./terraform.tfvars.template) to "terraform.tfvars" and fill the values.
```bash
cp terraform.tfvars.template terraform.tfvars
```
Make sure to set the required variables.


### Initialize Terraform, plan and apply
After the values are populated in "terraform.tfvars" initialize terraform, plan and apply.
```bash
terraform init
terraform plan -var-file=terraform.tfvars -out tfplan
terraform apply tfplan
```

## Post-actions
After deploying the AKS cluster, perform the following actions:
* Push images to GCR - Push all relevant images, including the Fabric image, to the Artifact Registry (GCR) created by this Terraform module.
* Create DNS record -  Point your domain's DNS to the DNS zone that is created by this Terraform module (point *.site.domain.com to the LB).

### Configure grafana monitoring
To configure grafana monitoring ask K2view representative to generate a token and supply grafana agent configuration file.
Paste the configuration to [grafana-agent-values.yaml](./grafana-agent-values.yaml) and run ```terraform apply```
To enable monitoring set "deploy_grafana_agent" to "true".

## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.10 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.12.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.25.2 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.10 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| <a name="module_GKE_storage_classes"></a> [GKE\_storage\_classes](#module\_GKE\_storage\_classes) | ../Modules/Kubernetes/gke-storage-classes | n/a |
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 5.0.0 |
| <a name="module_cloud_dns"></a> [cloud\_dns](#module\_cloud\_dns) | ../Modules/Network/cloud-dns | n/a |
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 29.0.0 |
| <a name="module_service-accounts"></a> [service-accounts](#module\_service-accounts) | ../Modules/cloud-private-site/service-accounts | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | 9.0 |

## Resources
| Name | Type |
|------|------|
| [google_compute_global_address.private_services_ip](https://registry.terraform.io/providers/hashicorp/google/5.10/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/5.10/docs/resources/compute_router) | resource |
| [google_service_networking_connection.private_services_connection](https://registry.terraform.io/providers/hashicorp/google/5.10/docs/resources/service_networking_connection) | resource |
| [helm_release.grafana_agent](https://registry.terraform.io/providers/Hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/Hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/5.10/docs/data-sources/client_config) | data source |
| [kubernetes_service.nginx_lb](https://registry.terraform.io/providers/Hashicorp/kubernetes/2.25.2/docs/data-sources/service) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_deploy_grafana_agent"></a> [deploy\_grafana\_agent](#input\_deploy\_grafana\_agent) | A boolean flag to control whether to install grafana agent | `bool` | `false` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The disk size for cluster workers | `number` | `500` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for cluster workers | `string` | `"pd-standard"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for ingress | `string` | n/a | yes |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | The initial workers up | `number` | `1` | no |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view\_agent\_namespace) | The name of K2view agent namespace | `string` | `"k2view-agent"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version of the GKE cluster | `string` | `"1.28"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The GCP VM type for cluster workers | `string` | `"e2-highmem-4"` | no |
| <a name="input_max_node"></a> [max\_node](#input\_max\_node) | The maximum workers up | `number` | `3` | no |
| <a name="input_min_node"></a> [min\_node](#input\_min\_node) | The minimum workers up | `number` | `1` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the network in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | A boolean flag to control whether GKE cluster is regional or zonal | `bool` | `true` | no |
| <a name="input_secondary_cidr_pods"></a> [secondary\_cidr\_pods](#input\_secondary\_cidr\_pods) | Secondary CIDR range for pods | `string` | `"10.176.0.0/14"` | no |
| <a name="input_secondary_cidr_services"></a> [secondary\_cidr\_services](#input\_secondary\_cidr\_services) | Secondary CIDR range for services | `string` | `"10.180.0.0/20"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | Primary CIDR range for a subnet | `string` | `"10.130.0.0/16"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones for GKE master and worker nodes | `list(string)` | <pre>[<br>  "a",<br>  "b"<br>]</pre> | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_cluster_dns_name_servers"></a> [cluster\_dns\_name\_servers](#output\_cluster\_dns\_name\_servers) | The cloud DNS name servers |
| <a name="output_loadBalancer_ip"></a> [loadBalancer\_ip](#output\_loadBalancer\_ip) | The IP of the load Balancer that point to nginx |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | VPC project id |
