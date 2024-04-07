resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.prefix_name}Vnet"
  address_space       = [ var.virtual_network_address_space ]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                 = "${var.prefix_name}Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [ var.subnet_address_prefixes ]
}

resource "azurerm_public_ip" "aks_nat_gateway_ip" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                = "${var.prefix_name}NatGatewayIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "aks_nat_gateway" {
  depends_on = [ azurerm_virtual_network.aks_vnet ]
  name                = "${var.prefix_name}NatGateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "aks_nat_gateway_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.aks_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.aks_nat_gateway_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_nat_gateway_association" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  nat_gateway_id = azurerm_nat_gateway.aks_nat_gateway.id
}
