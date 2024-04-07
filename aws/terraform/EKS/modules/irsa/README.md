# AWS IRSA Terraform module

Terraform module which creates Cloud Deployer and Fabric Space IRSA (IAM Roles for Service Accounts) resources on AWS. Currently, it gives access to S3, Keyspaces, and RDS resources.

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
| <a name="input_aws_region"></a> [aws_region](#input_aws_region) | The AWS region to run on. | `string` | `"eu-central-1"` | yes |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name) | Desired EKS Cluster Name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input_env) | Environment for tag (Dev/QA/Prod). | `string` | `"Dev"` | no |
| <a name="input_include_s3_permissions"></a> [include_s3_permissions](#input_include_s3_permissions) | Whether to include S3 permissions in the policy | `bool` | `true` | no |
| <a name="input_include_cassandra_permissions"></a> [include_cassandra_permissions](#input_include_cassandra_permissions) | Whether to include Cassandra permissions in the policy | `bool` | `true` | no |
| <a name="input_include_rds_permissions"></a> [include_rds_permissions](#input_include_rds_permissions) | Whether to include RDS permissions in the policy | `bool` | `true` | no |
| <a name="input_owner"></a> [owner](#input_owner) | Owner name for tag. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input_project) | Project name for tag. | `string` | n/a | no |

## Permissions

### IAM Fabric Space Role Permissions

#### Defines an IAM role that fabric pods will be assumed using k8s SA to interact with AWS resources

This role has permissions for the following actions:

- **Amazon S3**
  - `s3:PutObject`
  - `s3:GetObject`
  - `s3:DeleteObject`
  - `s3:ListBucket`
    - Resources: Buckets and objects prefixed with the tenant identifier.

- **Amazon Keyspaces (for Apache Cassandra)**
  - `cassandra:Create`
  - `cassandra:Drop`
  - `cassandra:Alter`
  - `cassandra:Select`
  - `cassandra:Modify`
    - Resources: All Keyspaces resources in the specified tenant.

- **Amazon RDS**
  - `rds-db:connect`
  - `rds-data:BatchExecuteStatement`
  - `rds-data:BeginTransaction`
  - `rds-data:CommitTransaction`
  - `rds-data:RollbackTransaction`
    - Resources: All RDS resources in the specified tenant.

### IAM Deployer Role Permissions

#### Defines an IAM role that Cloud Deployer pod will be assumed using k8s SA to interact with AWS resources

This role is granted permissions for:

- **Amazon S3**
  - `s3:CreateBucket`
  - `s3:DeleteBucket`
  - `s3:PutObject`
  - `s3:GetObject`
  - `s3:DeleteObject`
  - `s3:ListBucket`
    - Resources: Buckets and objects, with specific allowances for deletion of buckets prefixed with the tenant identifier.

- **Amazon Keyspaces (for Apache Cassandra)**
  - `cassandra:Alter`
  - `cassandra:Create`
  - `cassandra:Drop`
  - `cassandra:TagResource`
  - `cassandra:UntagResource`
    - Resources: All Keyspaces resources in the specified tenant.

- **Amazon RDS**
  - `rds:CreateDBCluster`
  - `rds:CreateDBInstance`
  - `rds:DeleteDBCluster`
  - `rds:DeleteDBInstance`
  - `rds:ModifyDBCluster`
  - `rds:ModifyDBInstance`
  - `rds:StartDBCluster`
  - `rds:StartDBInstance`
  - `rds:StopDBCluster`
  - `rds:StopDBInstance`
  - `rds:AddTagsToResource`
  - `rds:RemoveTagsFromResource`
    - Resources: All RDS resources in the specified tenant.