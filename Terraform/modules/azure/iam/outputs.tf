output "deployer_identity_client_id" {
    value = azurerm_user_assigned_identity.deployer_identity.client_id
    description = "Client ID of the deployer user-assigned managed identity"
}

output "space_identity_client_id" {
    value = azurerm_user_assigned_identity.space_identity.client_id
    description = "Client ID of the space user-assigned managed identity"
}

output "deployer_identity_id" {
    value = azurerm_user_assigned_identity.deployer_identity.id
    description = "Resource ID of the deployer user-assigned managed identity"
}
