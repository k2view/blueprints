# Google IAM Terraform Module

This module handles the creation of a Google Cloud Service Account and assigns specified IAM roles.

## Usage

```hcl
module "google_iam" {
  source = "./path/to/terraform-module-google-iam"

  project_id                   = "your-project-id"
  service_account_id           = "your-service-account-id"
  service_account_display_name = "Your Service Account Display Name"
}
