resource "random_string" "azurerm-cognitive-account-name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "cognitive-service" {
  name                = "CognitiveService-${random_string.azurerm-cognitive-account-name.result}"
  location            = azurerm_resource_group.challenge-rg.location
  resource_group_name = azurerm_resource_group.challenge-rg.name
  sku_name            = var.sku
  kind                = "CognitiveServices"
  identity {
    type = "SystemAssigned"
  }
}


#Create a private endpoint for Azure Cognitive Services
# resource "azurerm_private_endpoint" "edp-cognitive" {
#   name                = "edp-cognitive-service"
#   location            = azurerm_resource_group.challenge-rg.location
#   resource_group_name = azurerm_resource_group.challenge-rg.name
#   subnet_id           = azurerm_subnet.challenge-subnet.id

#   private_service_connection {
#     name                           = "cognitive-private-connection"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_cognitive_account.cognitive-service.id
#     subresource_names              = ["cog"]
#   }
# }