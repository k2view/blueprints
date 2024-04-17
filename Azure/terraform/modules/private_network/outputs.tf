output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
  description = "The ID of the AKS subnet created within the virtual network."
}

output "aks_public_ip" {
  value = azurerm_public_ip.aks_nat_gateway_ip.ip_address
  description = "The public IP address of the AKS private network."
}
