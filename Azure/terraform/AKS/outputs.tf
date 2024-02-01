
output "nginx_lb_ip" {
  value = module.AKS_ingress.nginx_lb_ip
  description = "The IP address of the load balancer associated with the Nginx ingress controller."
}

output "dns_name_servers" {
  value = module.DNS_zone.dns_name_servers
  description = "The list of name servers associated with the DNS zone created."
}

output "acr_user" {
  value = module.create_acr.acr_name
  description = "The username for the Azure Container Registry (ACR) created by the module."
}

output "acr_admin_password" {
  value = module.create_acr.acr_admin_password
  description = "The admin password for the Azure Container Registry (ACR), marked as sensitive."
  sensitive = true
}
