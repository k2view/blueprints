# AWS IRSA Terraform module

Terraform module which creates Cloud Deployer and Fabric Space IRSA (IAM Roles for Service Accounts) resources on AWS. Currently, it gives access to S3, Keyspaces, and RDS resources.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |


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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run on. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br>  "customer": "k2view",<br>  "env": "dev",<br>  "map-migrated": "mig42452",<br>  "owner": "k2v-devops",<br>  "project": "dev",<br>  "terraform": "true"<br>}</pre> | no |
| <a name="input_include_cassandra_deployer_permissions"></a> [include\_cassandra\_deployer\_permissions](#input\_include\_cassandra\_deployer\_permissions) | Whether to include Cassandra permissions in the deployer policy | `bool` | `true` | no |
| <a name="input_include_cassandra_space_permissions"></a> [include\_cassandra\_space\_permissions](#input\_include\_cassandra\_space\_permissions) | Whether to include Cassandra permissions in the space policy | `bool` | `true` | no |
| <a name="input_include_common_deployer_permissions"></a> [include\_common\_deployer\_permissions](#input\_include\_common\_deployer\_permissions) | Whether to include common permissions in the deployer policy | `bool` | `true` | no |
| <a name="input_include_msk_deployer_permissions"></a> [include\_msk\_deployer\_permissions](#input\_include\_msk\_deployer\_permissions) | Whether to include MSK permissions in the deployer policy | `bool` | `true` | no |
| <a name="input_include_msk_space_permissions"></a> [include\_msk\_space\_permissions](#input\_include\_msk\_space\_permissions) | Whether to include MSK permissions in the space policy | `bool` | `true` | no |
| <a name="input_include_opensearch_space_permissions"></a> [include\_opensearch\_space\_permissions](#input\_include\_opensearch\_space\_permissions) | Whether to include opensearch permissions in the space policy | `bool` | `true` | no |
| <a name="input_include_rds_deployer_permissions"></a> [include\_rds\_deployer\_permissions](#input\_include\_rds\_deployer\_permissions) | Whether to include RDS permissions in the deployer policy | `bool` | `true` | no |
| <a name="input_include_rds_space_permissions"></a> [include\_rds\_space\_permissions](#input\_include\_rds\_space\_permissions) | Whether to include RDS permissions in the space policy | `bool` | `true` | no |
| <a name="input_include_s3_deployer_permissions"></a> [include\_s3\_deployer\_permissions](#input\_include\_s3\_deployer\_permissions) | Whether to include S3 permissions in the deployer policy | `bool` | `true` | no |
| <a name="input_include_s3_space_permissions"></a> [include\_s3\_space\_permissions](#input\_include\_s3\_space\_permissions) | Whether to include S3 permissions in the space policy | `bool` | `true` | no |
| <a name="input_include_secret_manager_space_permissions"></a> [include\_secret\_manager\_space\_permissions](#input\_include\_secret\_manager\_space\_permissions) | Whether to include secret manager space permissions in the space policy | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_deployer_role_arn"></a> [iam\_deployer\_role\_arn](#output\_iam\_deployer\_role\_arn) | The ARN of the IAM deployer role |
| <a name="output_iam_space_role_arn"></a> [iam\_space\_role\_arn](#output\_iam\_space\_role\_arn) | The ARN of the IAM deployer role |
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

- **Amazon Secret Manager**
  - `secretsmanager:GetSecretValue`

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

<!-- END_TF_DOCS -->