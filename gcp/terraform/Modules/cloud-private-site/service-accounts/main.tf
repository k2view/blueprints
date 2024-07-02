### DEPLOYER SA ###
# Replace cluster name to be with underscores instead of dashes
locals {
  cluster_name_underscore = replace(var.cluster_name, "-", "_")
}

resource "google_service_account" "deployer_service_account" {
  account_id   = "${var.cluster_name}-deployer-sa"
  display_name = "Deployer Service Account for ${var.cluster_name} cluster"
}

# Create custom role for deployer
resource "google_project_iam_custom_role" "deployer_custom_role" {
  role_id     = "${local.cluster_name_underscore}_deployer_role"
  title       = "Deployer Custom Role"
  description = "Custom role with all necessary permissions for deployer"
  permissions = var.deployer_permissions
  project     = var.project_id
}

# Role to SA
resource "google_project_iam_member" "deployer_custom_role_binding" {
  depends_on = [google_service_account.deployer_service_account]
  project    = var.project_id
  role       = "projects/${var.project_id}/roles/${local.cluster_name_underscore}_deployer_role"
  member     = "serviceAccount:${google_service_account.deployer_service_account.email}"
}

# SA to KSA
resource "google_service_account_iam_member" "deployer_workload_identity_binding" {
  depends_on         = [google_service_account.deployer_service_account]
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.cluster_name}-deployer-sa@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k2view_agent_namespace}/k2view-agent-sa]"
}


### SPACE SA ###
resource "google_service_account" "space_service_account" {
  account_id   = "${var.cluster_name}-space-sa"
  display_name = "Space Service Account for ${var.cluster_name} cluster"
}

resource "google_project_iam_member" "space_roles" {
  depends_on = [google_service_account.space_service_account]
  for_each   = toset(var.space_roles)
  project    = var.project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.space_service_account.email}"
}
