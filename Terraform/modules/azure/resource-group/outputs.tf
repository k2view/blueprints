output "resource-group-name" {
  value       = azurerm_resource_group.rg[0].name
  description = "Name of the created resource group"
}
