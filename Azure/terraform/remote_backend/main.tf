# Adding random string for unique storage account name
resource "random_string" "storage_suffix" {
  count   = data.azurerm_resource_group.existing_rg.id != null ? 1 : 0 
  length  = 6
  special = false
  upper   = false
}

# Adding Azure Storage Account creation
resource "azurerm_storage_account" "tfstate_storage" {
  count                     = data.azurerm_resource_group.existing_rg.id != null ? 1 : 0
  name                      = "tfstate${random_string.storage_suffix[count.index].result}"
  resource_group_name       = data.azurerm_resource_group.existing_rg.name
  location                  = data.azurerm_resource_group.existing_rg.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type

  tags                      = var.tags
}

# Adding Blob Container creation for tfstate files
resource "azurerm_storage_container" "tfstate_container" {
  count                 = data.azurerm_resource_group.existing_rg.id != null ? 1 : 0
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_storage[0].name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.tfstate_storage]
}