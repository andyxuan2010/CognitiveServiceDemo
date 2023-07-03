resource "random_string" "azurerm-cognitive-account-name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "cognitive-service" {
  name                          = "CognitiveService-${random_string.azurerm-cognitive-account-name.result}"
  location                      = azurerm_resource_group.challenge-rg.location
  resource_group_name           = azurerm_resource_group.challenge-rg.name
  sku_name                      = var.sku
  custom_subdomain_name         = "basf-challenge"
  public_network_access_enabled = false
  kind                          = "OpenAI"
  #kind                = "CognitiveServices"
  identity {
    type = "SystemAssigned"
  }
}

# ### Azure Open AI Model - Chat GPT
resource "azurerm_cognitive_deployment" "gpt35-deployment" {
  name                 = "chatgpt35-model"
  cognitive_account_id = resource.azurerm_cognitive_account.cognitive-service.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }

  scale {
    type = "Standard"
  }
}


#Create a private endpoint for Azure Cognitive Services
resource "azurerm_private_endpoint" "edp-cognitive" {
  name                = "edp-cognitive-service"
  location            = azurerm_resource_group.challenge-rg.location
  resource_group_name = azurerm_resource_group.challenge-rg.name
  subnet_id           = azurerm_subnet.challenge-subnet.id

  private_service_connection {
    name                           = "cognitive-private-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive-service.id
    subresource_names              = ["account"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.local.id]
  }
}

resource "azurerm_private_dns_zone" "local" {
  name                = "privatelink.local"
  resource_group_name = azurerm_resource_group.challenge-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vl-basf-challenge" {
  name                  = "vl-basf-challenge"
  resource_group_name   = azurerm_resource_group.challenge-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.local.name
  virtual_network_id    = azurerm_virtual_network.challenge-vnet.id
  registration_enabled  = true
}