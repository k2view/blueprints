output "aks_subnet_id" {
  value = var.create_network ? azurerm_subnet.aks_subnet[0].id : var.subnet_id
  description = "The ID of the AKS subnet created within the virtual network."
}
