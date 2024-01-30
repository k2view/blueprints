resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

resource "azurerm_role_assignment" "role_acrpull" {
  depends_on                       = [ azurerm_container_registry.acr ]
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.principal_id
  skip_service_principal_aad_check = true
}

# Fetch the details of the created ACR
data "azurerm_container_registry" "acr" {
  name                = azurerm_container_registry.acr.name
  resource_group_name = var.resource_group_name
}
