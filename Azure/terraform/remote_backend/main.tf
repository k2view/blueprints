resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Adding random string for unique storage account name
resource "random_string" "storage_suffix" { 
  length  = 6
  special = false
  upper   = false
}

# Adding Azure Storage Account creation
resource "azurerm_storage_account" "tfstate_storage" {
  name                      = var.storage_account_name != "" ? var.storage_account_name : "tfstate${random_string.storage_suffix.result}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type

  tags                      = var.tags
}

# Adding Blob Container creation for tfstate files
resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_storage[0].name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.tfstate_storage]
}