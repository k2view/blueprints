output "name" {
  value = azurerm_virtual_network.aks_vnet.name
  description = "The name of the vnet"
}

output "nat_gateway_id" {
    value = azurerm_nat_gateway.aks_nat_gateway[0].id
}

output "route_table_id" {
    value = var.create_route_table ? azurerm_route_table.route_table[0].id : ""
}