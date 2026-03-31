# GCP GKE Module (v35.0.0)
Creates a private GKE cluster using the `terraform-google-modules/kubernetes-engine/google//modules/private-cluster` module (v35.0.0). Also provisions a dedicated GKE service account and the default storage class.

## Usage
```hcl
module "gke" {
  source = "./modules/gcp/gke"

  project_id   = "my-gcp-project"
  cluster_name = "my-cluster"
  region       = "europe-west3"
  network_name = module.vpc.network_name
  subnet_name  = "${var.cluster_name}-subnet-01"
}
```

## Requirements
| Name | Version |
|------|---------|
| google | >= 4.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| gke | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 35.0.0 |
| gke-service-account | ../iam/gke-service-account | n/a |
| storage-class | ../storage-class | n/a |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| cluster_name | GKE cluster name | `string` | n/a | yes |
| region | GCP region for the cluster | `string` | `"europe-west3"` | no |
| network_name | VPC network name to deploy the cluster into | `string` | `""` | no |
| subnet_name | Subnet name to deploy the cluster into | `string` | `""` | no |
| regional | Whether the cluster is regional (true) or zonal (false) | `bool` | `true` | no |
| kubernetes_version | Kubernetes version for the GKE cluster | `string` | `"1.34"` | no |
| machine_type | GCE machine type for worker nodes | `string` | `"e2-highmem-4"` | no |
| min_node | Minimum number of worker nodes per zone | `number` | `1` | no |
| max_node | Maximum number of worker nodes per zone | `number` | `3` | no |
| initial_node_count | Initial number of worker nodes per zone | `number` | `1` | no |
| disk_size_gb | Boot disk size in GB for worker nodes | `number` | `500` | no |
| disk_type | Boot disk type for worker nodes | `string` | `"pd-standard"` | no |
| storage_class_type | GCP persistent disk type for the default storage class | `string` | `"pd-balanced"` | no |
| zones | Zone suffixes for GKE nodes (e.g. ["a", "b"]) | `list(string)` | `["a", "b"]` | no |

## Outputs
| Name | Description |
|------|-------------|
| endpoint | GKE cluster API server endpoint |
| ca_certificate | Base64-encoded cluster CA certificate |
