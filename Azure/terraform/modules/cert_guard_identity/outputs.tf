output "managed_user_client_id" {
  description = "The Client ID of the Cert Guardian identity, required for the helm charts deployment."
  value = azurerm_user_assigned_identity.cert_guardian_identity.client_id
}