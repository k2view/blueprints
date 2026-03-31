# GCP GKE Service Account Module
Creates a GCP service account for GKE nodes and grants it the minimum required IAM roles: log writer, metric writer, monitoring viewer, resource metadata writer, autoscaling metrics writer, and Artifact Registry reader.

## Usage
```hcl
module "gke-service-account" {
  source = "./modules/gcp/iam/gke-service-account"

  project_id                   = "my-gcp-project"
  service_account_id           = "my-cluster-gke-sa"
  service_account_display_name = "my-cluster-gke-sa"
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
| [google_service_account.gke_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_project_iam_member.gke_sa_log_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_sa_metric_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_sa_monitoring_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_sa_resource_metadata_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_sa_metrics_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_sa_ar_reader](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| service_account_id | Service account ID (the part before @project.iam.gserviceaccount.com) | `string` | n/a | yes |
| service_account_display_name | Display name for the service account | `string` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| service_account_email | Email of the created service account |
