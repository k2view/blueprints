resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_dns_zone" "dns_public" {
  name                = var.domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "nginx_dns_record" {
  name                = var.dns_record_name
  zone_name           = azurerm_dns_zone.dns_public.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [ var.record_ip ]
}

resource "azurerm_dns_a_record" "nginx_root_dns_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_public.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [ var.record_ip ]
}