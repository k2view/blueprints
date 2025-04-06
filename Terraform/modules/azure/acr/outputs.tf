# output "acr_admin_password" {
#   value = data.azurerm_container_registry.acr.admin_password
#   description = "The admin password for the ACR."
#   sensitive = true
# }

output "acr_name" {
  value = var.use_existing_acr ? data.azurerm_container_registry.existing_acr[0].name : azurerm_container_registry.acr[0].name
}

output "acr_id" {
  value = var.use_existing_acr ? data.azurerm_container_registry.existing_acr[0].id : azurerm_container_registry.acr[0].id
}