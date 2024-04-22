output "storage_account_name" {
  value         = azurerm_storage_account.tfstate_storage[0].name
  description   = "The name of the Azure Storage Account used to store Terraform states."
}