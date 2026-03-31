# GCP Storage Class Module
Deploys a GCP Persistent Disk storage class to a GKE cluster via Helm.

## Usage
```hcl
module "storage-class" {
  source = "./modules/gcp/storage-class"

  region             = "europe-west3"
  storage_class_type = "pd-balanced"
}
```

## Requirements
| Name | Version |
|------|---------|
| helm | >= 2.0 |

## Providers
| Name | Version |
|------|---------|
| [helm](https://registry.terraform.io/providers/hashicorp/helm/latest) | >= 2.0 |

## Resources
| Name | Type |
|------|------|
| [helm_release.gcp-pd-storage-class](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | GCP region for the storage class | `string` | `"europe-west3"` | no |
| storage_class_type | GCP persistent disk type (e.g. pd-balanced, pd-ssd, pd-standard) | `string` | `"pd-balanced"` | no |
