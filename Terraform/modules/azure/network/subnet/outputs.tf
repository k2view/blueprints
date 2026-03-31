output "subnet_id" {
    value = azurerm_subnet.aks_subnet.id
    description = "Resource ID of the created subnet"
}
