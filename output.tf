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

# output "private_endpoint_url" {
#   value = azurerm_private_endpoint.edp-cognitive.private_service_connection[0].private_endpoint_connections[0].private_endpoint.ip_address
# }