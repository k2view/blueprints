# GCP Cloud DNS Module
Creates a public Cloud DNS managed zone with DNSSEC enabled, and two A records (wildcard `*` and root `@`) pointing to a load balancer IP.

## Usage
```hcl
module "dns" {
  source = "./modules/gcp/network/dns"

  project_id = "my-gcp-project"
  name       = "my-cluster-dns"
  domain     = "k2view.example.com"
  lb_ip      = "1.2.3.4"
}
```

## Requirements
| Name | Version |
|------|---------|
| google | >= 4.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| [cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest) | terraform-google-modules/cloud-dns/google | 5.3.0 |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| domain | Domain name for the Cloud DNS public zone | `string` | n/a | yes |
| name | Cloud DNS managed zone name | `string` | n/a | yes |
| lb_ip | IP address of the load balancer to point DNS records at | `string` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| cloud_dns | Name of the Cloud DNS managed zone |
