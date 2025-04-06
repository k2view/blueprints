output "cloud_dns" {
  value       = module.cloud-dns.name
  description = "The cloud DNS for the cluster created"
}