output "dns_name_servers" {
  value = azurerm_dns_zone.dns_public.name_servers
  description = "The name servers associated with the Azure DNS zone."
}
