output "resource_group_name" {
  value = azurerm_resource_group.challenge-rg.name
}

output "azurerm_cognitive_account_name" {
  value = azurerm_cognitive_account.cognitive-service.name
}

# Output the endpoint and private endpoint URL
output "cognitive-service-endpoint" {
  value = azurerm_cognitive_account.cognitive-service.endpoint
}

output "private_endpoint_url" {
  value = azurerm_private_endpoint.edp-cognitive.custom_dns_configs[0].fqdn
}

output "private_endpoint_private_ips" {
  value = azurerm_private_endpoint.edp-cognitive.custom_dns_configs[0].ip_addresses
}