locals {
  cluster_name_underscore = replace(var.cluster_name, "-", "_")
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_principal_id
}

data "azurerm_resource_group" "resource_group_data" {
  name = var.resource_group_name
}

# Deployer
resource "azurerm_user_assigned_identity" "deployer_identity" {
  name                = "${local.cluster_name_underscore}_deployer_identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "deployer_identity_contributor" {
  depends_on = [ azurerm_user_assigned_identity.deployer_identity ]
  scope = data.azurerm_resource_group.resource_group_data.id
  role_definition_name = "Managed Identity Contributor"
  principal_id = azurerm_user_assigned_identity.deployer_identity.principal_id
}

resource "azurerm_role_assignment" "deployer_contributor" {
  depends_on = [ azurerm_user_assigned_identity.deployer_identity ]
  scope = data.azurerm_resource_group.resource_group_data.id
  role_definition_name = "Contributor"
  principal_id = azurerm_user_assigned_identity.deployer_identity.principal_id
}

# resource "azurerm_federated_identity_credential" "deployer_identity_credential" {
#   name                = "${local.cluster_name_underscore}_deployer_identity"
#   resource_group_name = var.resource_group_name
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = var.kubernetes_oidc_issuer_url
#   parent_id           = azurerm_user_assigned_identity.deployer_identity.id
#   subject             = "system:serviceaccount:${var.k2view_agent_namespace}:${var.k2view_agent_namespace}-sa"
# }

# Space
resource "azurerm_user_assigned_identity" "space_identity" {
  name                = "${local.cluster_name_underscore}_space_identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "example_worker_blob_contributor" {
  depends_on = [ azurerm_user_assigned_identity.space_identity ]
  scope = data.azurerm_resource_group.resource_group_data.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = azurerm_user_assigned_identity.space_identity.principal_id
}

resource "azurerm_role_assignment" "example_space_keyvault_secrets_user" {
  depends_on = [ azurerm_user_assigned_identity.space_identity ]
  scope = data.azurerm_resource_group.resource_group_data.id
  role_definition_name = "Key Vault Secrets User"
  principal_id = azurerm_user_assigned_identity.space_identity.principal_id
}