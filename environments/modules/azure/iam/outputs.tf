output "deployer_identity_client_id" {
    value = azurerm_user_assigned_identity.deployer_identity.client_id
    description = "Principal ID of the K8S cluster"
}

output "space_identity_client_id" {
    value = azurerm_user_assigned_identity.space_identity.client_id
    description = "Principal ID of the K8S cluster"
}

output "deployer_identity_id" {
    value = azurerm_user_assigned_identity.deployer_identity.id
    description = "The ID of the deployer identity"
}