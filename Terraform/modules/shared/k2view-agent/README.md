# k2view-agent
This module deploys the k2view-agent onto a Kubernetes cluster using the official Helm chart. The agent connects to the k2view cloud manager via a mailbox and handles provisioning of k2view spaces. Cloud-provider-specific configuration (AWS, GCP, Azure) is passed to the agent as Helm values.

## Usage
The module requires only `mailbox_id`. All cloud-provider-specific inputs are optional and provider-agnostic by default.

### AWS
```hcl
module "k2view-agent" {
  count            = var.mailbox_id != "" ? 1 : 0
  source           = "../modules/shared/k2view-agent"
  mailbox_id       = var.mailbox_id
  mailbox_url      = var.mailbox_url
  cloud_provider   = "AWS"
  region           = var.region
  subnets          = var.subnets
  deployer_iam_arn = var.deployer_iam_arn
  space_iam_arn    = var.space_iam_arn
}
```

### GCP
```hcl
module "k2view-agent" {
  count                    = var.mailbox_id != "" ? 1 : 0
  source                   = "../modules/shared/k2view-agent"
  mailbox_id               = var.mailbox_id
  mailbox_url              = var.mailbox_url
  cloud_provider           = "GCP"
  region                   = var.region
  project                  = var.project
  project_id               = var.project_id
  network_name             = var.network_name
  subnet_name              = var.subnet_name
  gcp_service_account_name = var.gcp_service_account_name
}
```

### Azure
```hcl
module "k2view-agent" {
  count                             = var.mailbox_id != "" ? 1 : 0
  source                            = "../modules/shared/k2view-agent"
  mailbox_id                        = var.mailbox_id
  mailbox_url                       = var.mailbox_url
  cloud_provider                    = "AZURE"
  region                            = var.region
  azure_subscription_id             = var.azure_subscription_id
  azure_resource_group_name         = var.azure_resource_group_name
  azure_oidc_issuer_url             = var.azure_oidc_issuer_url
  azure_workload_identity_client_id = var.azure_workload_identity_client_id
  azure_space_identity_client_id    = var.azure_space_identity_client_id
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
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID. | `string` | n/a | yes |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider identifier (e.g. `aws`, `gcp`, `azure`). Sets the CLOUD secret and service account provider. | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | k2view agent Docker image URL. | `string` | `"docker.share.cloud.k2view.com/k2view/k2v-agent:latest"` | no |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud manager API URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for the k2view-agent Helm release. | `string` | `"k2view-agent"` | no |
| <a name="input_region"></a> [region](#input\_region) | Cloud region name passed to the agent. | `string` | `""` | no |
| <a name="input_deployer_iam_arn"></a> [deployer\_iam\_arn](#input\_deployer\_iam\_arn) | ARN of the AWS IAM role used by the deployer service account. AWS only. | `string` | `""` | no |
| <a name="input_space_iam_arn"></a> [space\_iam\_arn](#input\_space\_iam\_arn) | ARN of the AWS IAM role used by spaces (Fabric). AWS only. | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Comma-separated subnet IDs passed to the agent. AWS only. | `string` | `""` | no |
| <a name="input_gcp_service_account_name"></a> [gcp\_service\_account\_name](#input\_gcp\_service\_account\_name) | GCP service account name annotated on the deployer Kubernetes service account. GCP only. | `string` | `""` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | VPC/network name passed to the agent. GCP only. | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project name passed to the agent. GCP only. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID annotated on the deployer service account. GCP only. | `string` | `""` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Subnet name passed to the agent. GCP only. | `string` | `""` | no |
| <a name="input_azure_oidc_issuer_url"></a> [azure\_oidc\_issuer\_url](#input\_azure\_oidc\_issuer\_url) | Azure AKS OIDC issuer URL for workload identity federation. Azure only. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Azure resource group name passed to the agent. Azure only. | `string` | `""` | no |
| <a name="input_azure_space_identity_client_id"></a> [azure\_space\_identity\_client\_id](#input\_azure\_space\_identity\_client\_id) | Azure managed identity client ID for space workloads. Azure only. | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID passed to the agent. Azure only. | `string` | `""` | no |
| <a name="input_azure_workload_identity_client_id"></a> [azure\_workload\_identity\_client\_id](#input\_azure\_workload\_identity\_client\_id) | Azure workload identity client ID for the deployer service account. Azure only. | `string` | `""` | no |
| <a name="input_azure_workload_identity_id"></a> [azure\_workload\_identity\_id](#input\_azure\_workload\_identity\_id) | Azure workload identity object/principal ID. Azure only. | `string` | `""` | no |
| <a name="input_helm_user_values_json"></a> [helm\_user\_values\_json](#input\_helm\_user\_values\_json) | JSON string of user-defined Helm values to override space deployment defaults. | `string` | `""` | no |

## Outputs
No outputs.
