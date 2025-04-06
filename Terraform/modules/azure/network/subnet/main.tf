resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.prefix_name}Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [ var.subnet_address_prefixes ]
}

resource "azurerm_subnet_nat_gateway_association" "aks_nat_gateway_association" {
  subnet_id           = azurerm_subnet.aks_subnet.id
  nat_gateway_id      = var.nat_gateway_id
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_assoc" {
  count               = var.create_route_table ? 1 : 0
  subnet_id           = azurerm_subnet.aks_subnet.id
  route_table_id      = var.route_table_id
}