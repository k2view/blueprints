# GCP VPC Module
Creates a GCP VPC with two subnets (cluster + NAT), secondary IP ranges for GKE pods and services, a Cloud NAT gateway, a private services connection for managed databases (AlloyDB/Cloud SQL), and a firewall rule for SSH access.

## Usage
```hcl
module "vpc" {
  source = "./modules/gcp/network/vpc"

  project_id   = "my-gcp-project"
  cluster_name = "my-cluster"
  region       = "europe-west3"
}
```

## Requirements
| Name | Version |
|------|---------|
| google | >= 4.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| [vpc](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest) | terraform-google-modules/network/google | 10.0.0 |
| [cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest) | terraform-google-modules/cloud-nat/google | 5.3.0 |

## Resources
| Name | Type |
|------|------|
| [google_compute_global_address.private_services_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_firewall.nat_instance_firewall_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_service_networking_connection.private_services_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| cluster_name | GKE cluster name (used for resource naming) | `string` | n/a | yes |
| region | GCP region for all resources | `string` | `"europe-west3"` | no |
| network_name | VPC network name (defaults to `<cluster_name>-vpc`) | `string` | `""` | no |
| subnet_cidr | Primary CIDR range for the cluster subnet | `string` | `"10.130.0.0/20"` | no |
| secondary_cidr_pods | Secondary CIDR range for GKE pods | `string` | `"10.176.0.0/18"` | no |
| secondary_cidr_services | Secondary CIDR range for GKE services | `string` | `"10.180.0.0/20"` | no |
| nat_subnet_cidr | CIDR range for the NAT subnet | `string` | `"10.133.0.0/26"` | no |
| gcp_console_access_cidr | GCP Cloud Shell CIDR range allowed for SSH access to the NAT instance | `string` | `"35.235.240.0/20"` | no |

## Outputs
| Name | Description |
|------|-------------|
| network_name | Name of the created VPC |
