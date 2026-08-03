output "acr_name" {
  description = "The name of the ACR (created or existing). Empty when no ACR is managed (create_acr and use_existing_acr both false)."
  value       = try(concat(azurerm_container_registry.acr[*].name, data.azurerm_container_registry.existing_acr[*].name)[0], "")
}

output "acr_id" {
  description = "The resource ID of the ACR (created or existing). Empty when no ACR is managed (create_acr and use_existing_acr both false)."
  value       = try(concat(azurerm_container_registry.acr[*].id, data.azurerm_container_registry.existing_acr[*].id)[0], "")
}