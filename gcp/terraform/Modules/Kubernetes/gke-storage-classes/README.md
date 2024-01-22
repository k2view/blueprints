# gke-storage-classes
deploy regional disk storage class

## Usage
Basic usage of this submodule is as follows:
```hcl
module "gke-storage-classes" {
  source                  = "./Kubernetes/gke-storage-classes"
  input_region            = var.region
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |


## Resources

| Name | Type |
|------|------|
| [helm_release.gcp-pd-storage-class_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
