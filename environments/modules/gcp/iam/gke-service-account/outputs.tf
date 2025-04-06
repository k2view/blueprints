output "service_account_email" {
  value       = google_service_account.gke_service_account.email
  description = "The email of the created service account."
}
