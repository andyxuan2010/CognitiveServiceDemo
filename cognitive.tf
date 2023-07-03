resource "random_string" "azurerm-cognitive-account-name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# resource "azurerm_cognitive_account" "cognitive-service" {
#   name                = "CognitiveService-${random_string.azurerm-cognitive-account-name.result}"
#   location            = azurerm_resource_group.challenge-rg.location
#   resource_group_name = azurerm_resource_group.challenge-rg.name
#   sku_name            = var.sku
#   kind                = "CognitiveServices"
# identity {
#   type = "SystemAssigned"
# }
# }