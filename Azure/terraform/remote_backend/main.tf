resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Adding random string for unique storage account name
resource "random_string" "storage_suffix" { 
  count   = var.storage_account_name == "" ? 1 : 0
  length  = 6
  special = false
  numeric = true
  upper   = false
}

# Adding Azure Storage Account creation
resource "azurerm_storage_account" "tfstate_storage" {
  name                      = var.storage_account_name != "" ? var.storage_account_name : "tfstate${random_string.storage_suffix[0].result}"
  resource_group_name       = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type

  tags                      = var.tags
}

# Adding Blob Container creation for tfstate files
resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.tfstate_storage.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.tfstate_storage]
}