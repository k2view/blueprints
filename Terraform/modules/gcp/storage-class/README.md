<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.gcp-pd-storage-class](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The GCP region | `string` | `"europe-west3"` | no |
| <a name="input_storage_class_type"></a> [storage\_class\_type](#input\_storage\_class\_type) | The type of the storage class | `string` | `"pd-balanced"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->