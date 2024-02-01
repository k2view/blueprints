output "cluster_dns" {
  value       = google_dns_managed_zone.cluster_dns.name
  description = "The cloud DNS for the cluster created"
}

output "cluster_dns_name_servers" {
  value       = google_dns_managed_zone.cluster_dns.name_servers
  description = "The cloud DNS name servers"
}
