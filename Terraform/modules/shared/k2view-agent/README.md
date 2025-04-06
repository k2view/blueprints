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
| [helm_release.k2view_agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_oidc_issuer_url"></a> [azure\_oidc\_issuer\_url](#input\_azure\_oidc\_issuer\_url) | Azure OIDC Issuer URL | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Azure Resource Group Name | `string` | `""` | no |
| <a name="input_azure_space_identity_client_id"></a> [azure\_space\_identity\_client\_id](#input\_azure\_space\_identity\_client\_id) | Azure space identity client id | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure Subscription ID | `string` | `""` | no |
| <a name="input_azure_workload_identity_client_id"></a> [azure\_workload\_identity\_client\_id](#input\_azure\_workload\_identity\_client\_id) | Azure workload identity client id | `string` | `""` | no |
| <a name="input_azure_workload_identity_id"></a> [azure\_workload\_identity\_id](#input\_azure\_workload\_identity\_id) | Azure workload identity client id | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The name of the cloud provider. | `string` | `""` | no |
| <a name="input_deployer_iam_arn"></a> [deployer\_iam\_arn](#input\_deployer\_iam\_arn) | IAM of AWS role for deployer. | `string` | `""` | no |
| <a name="input_gcp_service_account_name"></a> [gcp\_service\_account\_name](#input\_gcp\_service\_account\_name) | GCP service account name. | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | k2view agent image url. | `string` | `"docker.share.cloud.k2view.com/k2view/k2v-agent:latest"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID. | `string` | n/a | yes |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud mailbox URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | k2view agent namespace name. | `string` | `"k2view-agent"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC. | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of GCP project. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Name of GCP project. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The name of the cloud region. | `string` | `""` | no |
| <a name="input_space_iam_arn"></a> [space\_iam\_arn](#input\_space\_iam\_arn) | IAM of AWS role for spaces. | `string` | `""` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the PG subnet. | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets names separated by comma - AWS only | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->