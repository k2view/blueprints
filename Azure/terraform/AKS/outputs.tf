
output "nginx_lb_ip" {
  value = module.AKS_ingress.nginx_lb_ip
}

output "dns_name_servers" {
  value = module.DNS_zone.dns_name_servers
}

output "acr_user" {
  value = module.create_acr.acr_name
}

output "acr_admin_password" {
  value = module.create_acr.acr_admin_password
  sensitive = true
}
