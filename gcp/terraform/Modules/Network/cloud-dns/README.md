# Terraform VPC Module

This submodule is part of the the `terraform-google-network` module. It creates a cloud DNS zone and connect it to LB.

It supports creating:

- A Cloud DNS zone
- DNS record set

## Usage

Basic usage of this submodule is as follows:

```hcl
module "vpc" {
    source  = "../GCP/Modules/Network/dns"
    
    project_id   = "<PROJECT ID>"
    cluster_name = "example-cluster"
    domain = "cluster.domain.com"
    lb_ip = "34.0.79.21"
}
```

## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Resources
| Name | Type |
|------|------|
| [google_dns_managed_zone.cluster_dns](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.cluster_dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | GKE cluster name for resources name. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain for cloud DNS. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment for tag (Dev/QA/Prod). | `string` | `"Dev"` | no |
| <a name="input_lb_ip"></a> [lb\_ip](#input\_lb\_ip) | IP of Load Balancer that point to this cluster. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner name for tag. | `string` | `"k2view"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tag, if cluster name will be empty it will replace cluster name in the names. | `string` | `"k2view-fabric"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region. | `string` | `"europe-west3"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_cluster_dns"></a> [cluster\_dns](#output\_cluster\_dns) | The cloud DNS for the cluster created |
| <a name="output_cluster_dns_name_servers"></a> [cluster\_dns\_name\_servers](#output\_cluster\_dns\_name\_servers) | The cloud DNS name servers |
