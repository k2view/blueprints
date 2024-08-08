provider "google" {
  project = var.project_id
  region  = "us-west1"
}

# Service Account Creation
resource "google_service_account" "cert_guardian_service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

# Custom Role Creation
resource "google_project_iam_custom_role" "certguardian_custom_role" {
  role_id     = "certguardian_role"
  title       = "Cert Guardian Custom Role"
  description = "set of rules needed for cert guardian to perform operation on DNS"
  permissions = [
    "dns.changes.create", 
    "dns.changes.get", 
    "dns.changes.list", 
    "dns.resourceRecordSets.create", 
    "dns.resourceRecordSets.delete", 
    "dns.resourceRecordSets.get", 
    "dns.resourceRecordSets.list", 
    "dns.resourceRecordSets.update", 
    "dns.managedZones.get", 
    "dns.managedZones.list"
    ]
}

# Assign the Custom Role to the Service Account at the Project Level
resource "google_project_iam_binding" "cert_guardian_service_account_binding" {
  project = var.project_id
  role = "projects/${var.project_id}/roles/${google_project_iam_custom_role.certguardian_custom_role.role_id}"
  members  = [
    "serviceAccount:${google_service_account.cert_guardian_service_account.email}",
  ]
}

# Assign IAM Roles to the Service Account for the Managed Zone
resource "google_dns_managed_zone_iam_member" "cert_guardian_service_account_zone_binding" {
  count       = var.managed_zone == "" ? 0 : 1
  managed_zone = var.managed_zone
  project     = var.project_id
  role        = "projects/${var.project_id}/roles/${google_project_iam_custom_role.certguardian_custom_role.role_id}"
  member      = "serviceAccount:${google_service_account.cert_guardian_service_account.email}"
}