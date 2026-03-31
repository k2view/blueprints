output "endpoint" {
  value       = module.gke.endpoint
  description = "GKE cluster API server endpoint"
}

output "ca_certificate" {
  value       = module.gke.ca_certificate
  description = "Base64-encoded cluster CA certificate"
}
