resource "random_string" "acr_suffix" {
  count   = var.use_existing_acr ? 0 : 1
  length  = 6
  special = false
  numeric = true
}

resource "azurerm_container_registry" "acr" {
  count               = var.use_existing_acr ? 0 : 1
  name                = var.acr_name != "" ? var.acr_name : "${random_string.acr_suffix[0].result}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

data "azurerm_container_registry" "existing_acr" {
  count               = var.use_existing_acr ? 1 : 0
  name                = var.existing_acr_name
  resource_group_name = var.existing_acr_resource_group
}