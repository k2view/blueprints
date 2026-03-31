# GCP Secrets Store CSI Driver Provider
Deploys the GCP provider for the Kubernetes Secrets Store CSI Driver via Helm. This enables GKE pods to mount secrets from Google Secret Manager as volumes.

## Usage
```hcl
module "secrets-store-csi-driver-provider-gcp" {
  source = "./modules/gcp/secrets-store-csi-driver-provider-gcp"
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
| [helm_release.secrets-store-csi-driver-provider-gcp](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
