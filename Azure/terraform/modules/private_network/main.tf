resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aksVnet"
  address_space       = [ var.virtual_network_address_space ]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks_subnet" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                 = "aksSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [ var.subnet_address_prefixes ]
}

resource "azurerm_public_ip" "aks_nat_gateway_ip" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                = "aksNatGatewayIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "aks_nat_gateway" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                = "aksNatGateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "aks_nat_gateway_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.aks_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.aks_nat_gateway_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_nat_gateway_association" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  nat_gateway_id = azurerm_nat_gateway.aks_nat_gateway.id
}
