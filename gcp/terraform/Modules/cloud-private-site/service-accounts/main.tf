# DEPLOYER SA
resource "google_service_account" "deployer_service_account" {
  account_id   = "${var.cluster_name}-deployer-sa"
  display_name = "Deployer Service Account for ${var.cluster_name} cluster"
}

resource "google_project_iam_member" "deployer_storage_role" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.deployer_service_account.email}"
}

resource "google_project_iam_member" "deployer_service_account_role" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.deployer_service_account.email}"
}

resource "google_project_iam_member" "deployer_alloydb_role" {
  project = var.project_id
  role    = "roles/alloydb.admin"
  member  = "serviceAccount:${google_service_account.deployer_service_account.email}"
}

resource "google_service_account_iam_member" "deployer_workload_identity_binding" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.cluster_name}-deployer-sa@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k2view_agent_namespace}/deployer-sa]"
}


# SPACE SA
resource "google_service_account" "space_service_account" {
  account_id   = "${var.cluster_name}-space-sa"
  display_name = "Space Service Account for ${var.cluster_name} cluster"
}

resource "google_project_iam_member" "space_storage_role" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.space_service_account.email}"
}

resource "google_project_iam_member" "space_alloydb_role" {
  project = var.project_id
  role    = "roles/alloydb.client"
  member  = "serviceAccount:${google_service_account.space_service_account.email}"
}
