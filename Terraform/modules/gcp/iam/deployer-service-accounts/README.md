<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_custom_role.deployer_custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.deployer_custom_role_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.space_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.deployer_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.space_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.deployer_workload_identity_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |
| <a name="input_deployer_permissions"></a> [deployer\_permissions](#input\_deployer\_permissions) | List of permissions for the deployer role | `list(string)` | <pre>[<br>  "storage.buckets.create",<br>  "storage.buckets.delete",<br>  "storage.buckets.get",<br>  "storage.buckets.list",<br>  "storage.objects.create",<br>  "storage.objects.delete",<br>  "storage.objects.get",<br>  "storage.objects.list",<br>  "iam.serviceAccounts.create",<br>  "iam.serviceAccounts.delete",<br>  "iam.serviceAccounts.get",<br>  "iam.serviceAccounts.list",<br>  "iam.serviceAccounts.update",<br>  "iam.serviceAccounts.getIamPolicy",<br>  "iam.serviceAccounts.setIamPolicy",<br>  "alloydb.clusters.create",<br>  "alloydb.clusters.delete",<br>  "alloydb.clusters.get",<br>  "alloydb.clusters.list",<br>  "alloydb.instances.create",<br>  "alloydb.instances.delete",<br>  "alloydb.instances.get",<br>  "alloydb.instances.list",<br>  "alloydb.operations.get",<br>  "alloydb.operations.list",<br>  "cloudsql.backupRuns.create",<br>  "cloudsql.backupRuns.delete",<br>  "cloudsql.backupRuns.get",<br>  "cloudsql.backupRuns.list",<br>  "cloudsql.databases.create",<br>  "cloudsql.databases.delete",<br>  "cloudsql.databases.get",<br>  "cloudsql.databases.list",<br>  "cloudsql.databases.update",<br>  "cloudsql.instances.create",<br>  "cloudsql.instances.delete",<br>  "cloudsql.instances.get",<br>  "cloudsql.instances.list",<br>  "cloudsql.instances.update",<br>  "cloudsql.sslCerts.create",<br>  "cloudsql.sslCerts.delete",<br>  "cloudsql.sslCerts.get",<br>  "cloudsql.sslCerts.list",<br>  "cloudsql.users.create",<br>  "cloudsql.users.delete",<br>  "cloudsql.users.list",<br>  "cloudsql.users.update"<br>]</pre> | no |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view\_agent\_namespace) | The name of K2view agent namespace | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID | `string` | n/a | yes |
| <a name="input_space_roles"></a> [space\_roles](#input\_space\_roles) | List of roles to assign to the space service account | `list(string)` | <pre>[<br>  "roles/storage.objectUser",<br>  "roles/cloudsql.client",<br>  "roles/iam.workloadIdentityUser",<br>  "roles/secretmanager.secretAccessor"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->