# Create a User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "cert_guardian_identity" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Configure Federated Identity Credential for the Managed Identity
resource "azurerm_federated_identity_credential" "cert_guardian_identity_credentials" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.kubernetes_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.cert_guardian_identity.id
  subject             = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

# Fetch existing DNS Zone
data "azurerm_dns_zone" "azure_dns_managed" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

# Assign "DNS Zone Contributor" role to the Managed Identity
resource "azurerm_role_assignment" "cert_guardian_dns_zone_contributor" {
  scope                 = data.azurerm_dns_zone.azure_dns_managed.id
  role_definition_name  = "DNS Zone Contributor"
  principal_id          = azurerm_user_assigned_identity.cert_guardian_identity.principal_id
}
