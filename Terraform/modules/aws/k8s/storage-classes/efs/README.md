# AWS EFS Storage Class Module
Creates an EFS file system with mount targets in each VPC subnet, an IRSA-enabled IAM role for the EFS CSI driver, and three Kubernetes storage classes (fabric, Cassandra, PostgreSQL) deployed via Helm.

## Usage
```hcl
module "efs" {
  source = "./modules/aws/k8s/storage-classes/efs"

  cluster_name         = "my-eks-cluster"
  aws_region           = "eu-central-1"
  vpc_subnets          = module.vpc.private_subnets
  vpc_cidr             = module.vpc.vpc_cidr_block
  node_group_role_name = module.eks.node_group_role_arn
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Providers
| Name | Version |
|------|---------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 5.0.0 |
| [helm](https://registry.terraform.io/providers/hashicorp/helm/latest) | n/a |
| [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest) | n/a |

## Resources
| Name | Type |
|------|------|
| [aws_efs_file_system.EKS_EFS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.AmazonEKS_EFS_CSI_DriverRole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_EFS_CSI_DriverRole_policy_attachment_to_nodegroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.EfsSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.efs_sc_fabric](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.efs_sc_cassandra](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.efs_sc_pg](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account.efs_csi_controller_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | EKS cluster name | `string` | n/a | yes |
| aws_region | AWS region where the EKS cluster is deployed | `string` | `"eu-central-1"` | no |
| vpc_subnets | List of VPC subnet IDs for EFS mount targets | `list` | `[]` | no |
| vpc_cidr | VPC CIDR block (used for EFS security group ingress rule) | `string` | `"10.0.0.0/16"` | no |
| node_group_role_name | IAM role name of the EKS node group | `string` | `""` | no |
| common_tags | Tags to apply to all resources | `map(string)` | `{...}` | no |

## Outputs
| Name | Description |
|------|-------------|
| efs_id | Resource ID of the EFS file system |
| efs_driver_SA_arn | ARN of the EFS CSI driver IAM role |
