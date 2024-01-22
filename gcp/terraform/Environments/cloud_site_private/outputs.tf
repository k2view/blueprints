output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.vpc.project_id
  description = "VPC project id"
}

output "loadBalancer_ip" {
  value       = data.kubernetes_service.nginx_lb.status.0.load_balancer.0.ingress.0.ip
  description = "The IP of the load Balancer that point to nginx"
}

output "cluster_dns_name_servers" {
  value       = module.cloud_dns.cluster_dns_name_servers
  description = "The cloud DNS name servers"
}
