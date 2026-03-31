# GCP VPC Multi-Subnet Module
Creates a GCP VPC with four subnets (dev, staging, prod, NAT), secondary IP ranges for GKE pods and services per environment, a Cloud NAT gateway, and a private services connection for managed databases.

## Usage
```hcl
module "vpc" {
  source = "./modules/gcp/network/vpc-multi-subnet"

  project_id   = "my-gcp-project"
  network_name = "my-network"
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
| [google_service_networking_connection.private_services_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| network_name | VPC network name | `string` | `""` | no |
| region | GCP region for all resources | `string` | `"europe-west3"` | no |
| dev_subnet_cidr | Primary CIDR range for the DEV subnet | `string` | `"10.130.0.0/20"` | no |
| dev_secondary_cidr_pods | Secondary CIDR range for DEV GKE pods | `string` | `"10.176.0.0/18"` | no |
| dev_secondary_cidr_services | Secondary CIDR range for DEV GKE services | `string` | `"10.176.64.0/20"` | no |
| staging_subnet_cidr | Primary CIDR range for the STAGING subnet | `string` | `"10.130.0.0/20"` | no |
| staging_secondary_cidr_pods | Secondary CIDR range for STAGING GKE pods | `string` | `"10.176.0.0/18"` | no |
| staging_secondary_cidr_services | Secondary CIDR range for STAGING GKE services | `string` | `"10.176.64.0/20"` | no |
| prod_subnet_cidr | Primary CIDR range for the PROD subnet | `string` | `"10.130.0.0/20"` | no |
| prod_secondary_cidr_pods | Secondary CIDR range for PROD GKE pods | `string` | `"10.176.0.0/18"` | no |
| prod_secondary_cidr_services | Secondary CIDR range for PROD GKE services | `string` | `"10.176.64.0/20"` | no |
| nat_subnet_cidr | CIDR range for the NAT subnet | `string` | `"10.130.0.0/20"` | no |

## Outputs
| Name | Description |
|------|-------------|
| network_name | Name of the created VPC |
