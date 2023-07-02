resource "random_string" "azurerm_cognitive_account_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "cognitive-service" {
  name                = "CognitiveService-${random_string.azurerm_cognitive_account_name.result}"
  location            = azurerm_resource_group.challenge-rg.location
  resource_group_name = azurerm_resource_group.challenge-rg.name
  sku_name            = var.sku
  kind                = "CognitiveServices"
}