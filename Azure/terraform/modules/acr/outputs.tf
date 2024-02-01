output "acr_admin_password" {
  value = data.azurerm_container_registry.acr.admin_password
  description = "The admin password for the ACR."
  sensitive = true
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
  description = "The name of the Azure Container Registry."
}
