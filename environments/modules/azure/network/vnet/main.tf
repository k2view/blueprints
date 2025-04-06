resource "azurerm_virtual_network" "aks_vnet" {
  name                 = "${var.prefix_name}Vnet"
  address_space        = [ var.virtual_network_address_space ]
  location             = var.location
  resource_group_name  = var.resource_group_name
  tags                 = var.tags
}

# NAT gateway
resource "azurerm_public_ip" "aks_nat_gateway_ip" {
  count               = var.create_nat_gateway ? 1 : 0
  depends_on          = [ azurerm_virtual_network.aks_vnet ]
  name                = "${var.prefix_name}NatGatewayIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "aks_nat_gateway" {
  count               = var.create_nat_gateway ? 1 : 0
  depends_on          = [ azurerm_virtual_network.aks_vnet ]
  name                = "${var.prefix_name}NatGateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "aks_nat_gateway_ip_association" {
  count                = var.create_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.aks_nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.aks_nat_gateway_ip[0].id
}

# Route table for userDefinedRouting
resource "azurerm_route_table" "route_table" {
  count               = var.create_route_table ? 1 : 0
  depends_on          = [ azurerm_virtual_network.aks_vnet ]
  name                = "${var.prefix_name}RouteTable"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "outbound_route" {
  count                  = var.create_route_table ? 1 : 0
  name                   = "${var.prefix_name}OutboundRoute"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = var.route_table_address_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.route_table_next_hop_ip
}