# Unique-name fallback for a new ACR when acr_name is empty.
resource "random_string" "acr_suffix" {
  count   = var.create_acr && !var.use_existing_acr ? 1 : 0
  length  = 6
  special = false
  numeric = true
}

# Create a new ACR (create_acr = true and use_existing_acr = false).
resource "azurerm_container_registry" "acr" {
  count               = var.create_acr && !var.use_existing_acr ? 1 : 0
  name                = var.acr_name != "" ? var.acr_name : "${random_string.acr_suffix[0].result}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

# Look up an existing ACR (use_existing_acr = true); must already exist.
data "azurerm_container_registry" "existing_acr" {
  count               = var.use_existing_acr ? 1 : 0
  name                = var.existing_acr_name
  resource_group_name = var.existing_acr_resource_group

  lifecycle {
    precondition {
      condition     = var.existing_acr_name != null && var.existing_acr_resource_group != null
      error_message = "When use_existing_acr = true, both existing_acr_name and existing_acr_resource_group must be set."
    }
  }
}
