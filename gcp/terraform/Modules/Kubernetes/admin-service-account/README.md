# Deploy admin service account
This sample terraform template deploys admin service account to kubernetes cluster

## Usage
Basic usage of this submodule is as follows:
```hcl
module "admin_service_account" {
  source       = "./modules/admin_user"
  name         = var.admin_service_account_name
  cluster_name = var.cluster_name
}
```

## Requirements

kubectl configs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding.full_admin_user](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_secret.full_admin_user_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.full_admin_user](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The service account name | `string` | `"full-admin-user"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_user_token"></a> [admin\_user\_token](#output\_admin\_user\_token) | n/a |
