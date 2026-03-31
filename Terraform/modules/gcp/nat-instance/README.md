# GCP NAT Instance Module
Creates a Compute Engine VM acting as a NAT gateway for private GKE nodes that need to reach specific IP ranges (e.g. an on-prem VPN endpoint). Traffic from GKE pods tagged `use-nat` is routed through this instance via a custom route.

This is distinct from Cloud NAT — use this when you need traffic to egress from a static private IP (e.g. for IP whitelisting on the destination side).

## Usage
```hcl
module "nat-instance" {
  source = "./modules/gcp/nat-instance"

  cluster_name = "my-cluster"
  region       = "europe-west3"
  vpc          = module.vpc.network_name
  subnet       = "${var.cluster_name}-nat-subnet-01"
  dest_range   = "192.168.1.0/24"
}
```

## Requirements
| Name | Version |
|------|---------|
| google | >= 4.0 |

## Providers
| Name | Version |
|------|---------|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | >= 4.0 |

## Resources
| Name | Type |
|------|------|
| [google_compute_address.nat_reserved_private_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_route.nat_instance_route](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_firewall.nat_instance_firewall_traffic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.nat_gateway](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | GKE cluster name (used for resource naming) | `string` | `""` | no |
| region | GCP region for the NAT instance | `string` | `""` | no |
| vpc | VPC network name for the NAT instance | `string` | `""` | no |
| subnet | Subnet name to deploy the NAT instance into | `string` | `""` | no |
| dest_range | Destination CIDR range to route through the NAT instance | `string` | `""` | no |
| instance_type | GCE machine type for the NAT instance | `string` | `"e2-medium"` | no |
| nat_instance_fw_ports | TCP ports to allow from GKE pods to the NAT instance | `list(string)` | `["5432"]` | no |
| nat_instance_ingress_gke | CIDR ranges of GKE pods allowed to reach the NAT instance | `list(string)` | `["10.176.0.0/14"]` | no |

## Outputs
| Name | Description |
|------|-------------|
| nat_reserved_ip | Internal IP of the NAT instance (use for VPN or firewall rules on the destination side) |
