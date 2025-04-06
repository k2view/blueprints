## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0.0 |


## Resources
| Name | Type |
|------|------|
| [aws_efs_file_system.EKS_EFS](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_targets](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.AmazonEKS_EFS_CSI_DriverRole](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment_to_nodegroup](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.EfsSecurityGroup](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.example](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run on. | `string` | `"eu-central-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_default_value"></a> [default\_value](#input\_default\_value) | The following value is a default value in order for terraform to apply (This i only used when in module mode) | `string` | `3` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment for tag (Dev/QA/Prod). | `string` | `"Dev"` | no |
| <a name="input_node_group_role_name"></a> [node\_group\_role\_name](#input\_node\_group\_role\_name) | EKS Cluster node group role name | `string` | `""` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner name for tag. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name for tag, if cluster name will be empty it will replace cluster name in the names. | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr block to be assigned to vpc | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | vpc\_subnets can be supploed - this must be used when this is used as a module | `list` | `[]` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_efs_driver_SA_arn"></a> [efs\_driver\_SA\_arn](#output\_efs\_driver\_SA\_arn) | n/a |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | n/a |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.EKS_EFS](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_targets](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.AmazonEKS_EFS_CSI_DriverRole](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment_to_nodegroup](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.EfsSecurityGroup](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.efs_sc_cassandra](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.efs_sc_fabric](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.efs_sc_pg](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account.efs_csi_controller_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.example](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run on. | `string` | `"eu-central-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br>  "env": "dev",<br>  "owner": "owner",<br>  "project": "dev",<br>  "terraform": "true"<br>}</pre> | no |
| <a name="input_node_group_role_name"></a> [node\_group\_role\_name](#input\_node\_group\_role\_name) | EKS Cluster node group role name | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block to be assigned to vpc | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | vpc\_subnets can be supploed - this must be used when this is used as a module | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_driver_SA_arn"></a> [efs\_driver\_SA\_arn](#output\_efs\_driver\_SA\_arn) | n/a |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | n/a |
<!-- END_TF_DOCS -->