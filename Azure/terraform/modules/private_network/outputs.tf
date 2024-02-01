output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
  description = "The ID of the AKS subnet created within the virtual network."
}
