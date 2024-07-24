
output "nginx_lb_ip" {
  value = var.deploy_ingress && !var.private_cluster_enabled ? module.AKS_ingress[0].nginx_lb_ip : var.lb_ip
  description = "The IP address of the load balancer associated with the Nginx ingress controller."
}

output "dns_name_servers" {
  value = var.create_dns ? module.DNS_zone[0].dns_name_servers : []
  description = "The list of name servers associated with the DNS zone created."
}

output "acr_user" {
  value = var.create_acr ? module.create_acr[0].acr_name : ""
  description = "The username for the Azure Container Registry (ACR) created by the module."
}

output "acr_admin_password" {
  value = var.create_acr ? module.create_acr[0].acr_admin_password : ""
  description = "The admin password for the Azure Container Registry (ACR), marked as sensitive."
  sensitive = true
}
