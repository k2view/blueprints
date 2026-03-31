# AWS IRSA Module
Creates IAM Roles for Service Accounts (IRSA) for K2view workloads on EKS. Two roles are provisioned:

- **Deployer role** — used by the K2view Cloud Deployer pod to manage AWS resources (S3, RDS, Keyspaces, MSK).
- **Space role** — used by K2view space pods to access AWS services (S3, RDS, Keyspaces, MSK, OpenSearch, Secrets Manager).

Both roles trust the EKS cluster's OIDC provider for workload identity federation.

## Usage
```hcl
module "irsa" {
  source       = "./modules/aws/irsa"

  aws_region   = "eu-central-1"
  cluster_name = "my-eks-cluster"
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
| [tls](https://registry.terraform.io/providers/hashicorp/tls/latest) | n/a |

## Resources
| Name | Type |
|------|------|
| [aws_iam_policy.iam_fabric_space_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_deployer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_fabric_space_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_deployer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.iam_fabric_space_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_deployer_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [tls_certificate.tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region where the EKS cluster is deployed | `string` | n/a | yes |
| cluster_name | EKS cluster name | `string` | n/a | yes |
| include_s3_space_permissions | Whether to include S3 permissions in the space policy | `bool` | `true` | no |
| include_cassandra_space_permissions | Whether to include Cassandra permissions in the space policy | `bool` | `true` | no |
| include_rds_space_permissions | Whether to include RDS permissions in the space policy | `bool` | `true` | no |
| include_msk_space_permissions | Whether to include MSK permissions in the space policy | `bool` | `true` | no |
| include_opensearch_space_permissions | Whether to include OpenSearch permissions in the space policy | `bool` | `true` | no |
| include_secret_manager_space_permissions | Whether to include Secrets Manager permissions in the space policy | `bool` | `true` | no |
| include_common_deployer_permissions | Whether to include common EC2/VPC permissions in the deployer policy | `bool` | `true` | no |
| include_s3_deployer_permissions | Whether to include S3 permissions in the deployer policy | `bool` | `true` | no |
| include_cassandra_deployer_permissions | Whether to include Cassandra permissions in the deployer policy | `bool` | `true` | no |
| include_rds_deployer_permissions | Whether to include RDS permissions in the deployer policy | `bool` | `true` | no |
| include_msk_deployer_permissions | Whether to include MSK permissions in the deployer policy | `bool` | `true` | no |
| common_tags | Tags to apply to all resources | `map(string)` | `{...}` | no |

## Outputs
| Name | Description |
|------|-------------|
| iam_deployer_role_arn | ARN of the IAM deployer role |
| iam_space_role_arn | ARN of the IAM space (fabric) role |
