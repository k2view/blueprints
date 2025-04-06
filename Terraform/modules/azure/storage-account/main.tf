locals {
  sanitized_cluster_name = replace(var.cluster_name, "-", "")
  storage_account_name   = "${local.sanitized_cluster_name}storageacc"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
}