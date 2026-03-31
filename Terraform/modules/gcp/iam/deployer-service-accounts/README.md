# GCP Deployer Service Accounts Module
Creates two GCP service accounts for K2view workloads and binds them to Kubernetes service accounts via Workload Identity:

- **Deployer SA** — runs the K2view Cloud Deployer. Gets a custom IAM role with permissions to manage GCS, AlloyDB, Cloud SQL, and IAM service accounts.
- **Space SA** — used by K2view spaces. Gets predefined roles: `storage.objectUser`, `cloudsql.client`, `iam.workloadIdentityUser`, `secretmanager.secretAccessor`.

## Usage
```hcl
module "deployer-service-accounts" {
  source = "./modules/gcp/iam/deployer-service-accounts"

  project_id             = "my-gcp-project"
  cluster_name           = "my-cluster"
  k2view_agent_namespace = "k2view-agent"
}
```

## Requirements
| Name | Version |
|------|---------|
| google | >= 4.0 |

## Providers
| Name | Version |
|------|---------|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | >= 4.0 |

## Resources
| Name | Type |
|------|------|
| [google_service_account.deployer_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.space_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_project_iam_custom_role.deployer_custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.deployer_custom_role_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.space_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account_iam_member.deployer_workload_identity_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| cluster_name | GKE cluster name | `string` | n/a | yes |
| k2view_agent_namespace | Kubernetes namespace for the K2view agent | `string` | n/a | yes |
| space_roles | IAM roles to assign to the space service account | `list(string)` | `[storage.objectUser, cloudsql.client, iam.workloadIdentityUser, secretmanager.secretAccessor]` | no |
| deployer_permissions | IAM permissions for the deployer custom role | `list(string)` | `[GCS, IAM SA, AlloyDB, Cloud SQL permissions]` | no |
