# AWS EKS Module
Creates an EKS cluster with a managed node group using the `terraform-aws-modules/eks/aws` module (v20). Includes IRSA support and configurable disk, instance, and autoscaling settings.

## Usage
```hcl
module "eks" {
  source = "./modules/aws/k8s/eks"

  eks_cluster_name         = "my-cluster"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| [eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) | terraform-aws-modules/eks/aws | ~> 20.0 |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks_cluster_name | EKS cluster name | `string` | n/a | yes |
| vpc_id | VPC ID for the cluster | `string` | n/a | yes |
| subnet_ids | Subnet IDs for worker nodes | `list(string)` | n/a | yes |
| control_plane_subnet_ids | Subnet IDs for the control plane | `list(string)` | n/a | yes |
| eks_cluster_version | Kubernetes version | `string` | `"1.34"` | no |
| eks_cluster_endpoint_public_access | Whether the API server endpoint is publicly accessible | `bool` | `false` | no |
| eks_instance_types | EC2 instance types for worker nodes | `list(string)` | `["t3.medium"]` | no |
| ami_type | AMI type for worker nodes | `string` | `"AL2_x86_64"` | no |
| min_size | Minimum number of worker nodes | `number` | `1` | no |
| max_size | Maximum number of worker nodes | `number` | `3` | no |
| desired_size | Desired number of worker nodes | `number` | `2` | no |
| capacity_type | Node group capacity type (ON_DEMAND or SPOT) | `string` | `"ON_DEMAND"` | no |
| disk_size | Root EBS volume size in GB | `number` | `100` | no |
| disk_type | Root EBS volume type | `string` | `"gp3"` | no |
| disk_iops | IOPS for the root EBS volume | `number` | `3000` | no |
| disk_throughput | Throughput in MB/s for the root EBS volume | `number` | `125` | no |
| disk_encryption_enabled | Whether to encrypt root EBS volumes | `bool` | `true` | no |
| custom_kms_key_arn | KMS key ARN for EBS encryption (uses default if not provided) | `string` | `null` | no |
| cluster_addons | Map of cluster addon configurations | `any` | `{coredns, kube-proxy, vpc-cni, aws-ebs-csi-driver, aws-efs-csi-driver}` | no |
| access_entries | Access entries for the EKS cluster | `map(any)` | `{}` | no |
| enable_cluster_creator_admin_permissions | Whether to grant the caller admin permissions | `bool` | `true` | no |
| authentication_mode | Authentication mode (API or CONFIG_MAP) | `string` | `"API"` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| cluster_name | EKS cluster name |
| cluster_id | EKS cluster ID |
| cluster_arn | EKS cluster ARN |
| cluster_endpoint | Kubernetes API server endpoint |
| cluster_version | Kubernetes version |
| cluster_certificate_authority_data | Base64-encoded cluster CA certificate |
| cluster_security_group_id | Security group ID of the cluster |
| cluster_primary_security_group_id | Primary security group ID |
| cluster_oidc_issuer_url | OIDC issuer URL |
| oidc_provider | OIDC provider URL (without https://) |
| oidc_provider_arn | OIDC provider ARN |
| cluster_iam_role_name | IAM role name of the cluster |
| cluster_iam_role_arn | IAM role ARN of the cluster |
| node_security_group_id | Security group ID shared by all nodes |
| node_group_role_arn | IAM role name of the node group |
| eks_managed_node_groups | Map of managed node group attributes |
| eks_managed_node_groups_autoscaling_group_names | Autoscaling group names for managed node groups |
