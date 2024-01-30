output "acr_admin_password" {
  value = data.azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}
