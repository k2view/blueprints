# Terraform Module for K2View Agent Deployment
This Terraform module facilitates the deployment of the K2View Agent in a cloud environment.

## Usage
This submodule can be used to deploy an K2view ajent into your Kubernetes cluster. Modify the following Terraform configuration to fit your specific requirements:
```hcl
module "AKS_k2v_agent" {
  depends_on              = [ azurerm_kubernetes_cluster.aks_cluster ]
  count                   = var.mailbox_id != "" ? 1 : 0
  source                  = "../modules/k2v_agent"
  mailbox_id              = var.mailbox_id    # k2view cloud mailbox ID
  mailbox_url             = var.mailbox_url   # k2view cloud mailbox URL
  region                  = var.location      # The name of the cloud region
  cloud                   = "azure"           # The name of the cloud provider.
  cloud_provider          = "azure"           # The name of the cloud provider.
}
```

## Providers
| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |


## Resources
| Name | Type |
|------|------|
| [helm_release.k2view_agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud"></a> [cloud](#input\_cloud) | The name of the cloud provider. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The name of the cloud provider. | `string` | `""` | no |
| <a name="input_deployer_iam_arn"></a> [deployer\_iam\_arn](#input\_deployer\_iam\_arn) | IAM of AWS role for deployer. | `string` | `""` | no |
| <a name="input_gcp_service_account_name"></a> [gcp\_service\_account\_name](#input\_gcp\_service\_account\_name) | GCP service account name. | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | k2view agent image url. | `string` | `"docker.share.cloud.k2view.com/k2view/k2v-agent:latest"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID. | `string` | n/a | yes |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud mailbox URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | k2view agent namespace name. | `string` | `"k2view-agent"` | no |
| <a name="input_project"></a> [project\_id](#input\_project) | Name of GCP project. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The name of the cloud region. | `string` | `""` | no |
| <a name="input_space_iam_arn"></a> [space\_iam\_arn](#input\_space\_iam\_arn) | IAM of AWS role for spaces. | `string` | `""` | no |
