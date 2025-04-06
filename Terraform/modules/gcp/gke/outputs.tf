output "endpoint" {
  value       = module.gke.endpoint
  description = "The email of the created service account."
}

output "ca_certificate" {
  value       = module.gke.ca_certificate
  description = "The email of the created service account."
}