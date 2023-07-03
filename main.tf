
resource "azurerm_resource_group" "challenge-rg" {
  name     = "challenge-rg"
  location = "West Europe"
  tags = merge(var.common_tags, {
    name = "challenge-rg"
  })
}
resource "azurerm_virtual_network" "challenge-vnet" {
  name                = "challenge-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.challenge-rg.location
  resource_group_name = azurerm_resource_group.challenge-rg.name
  tags = merge(var.common_tags, {
    name = "challenge-vnet"
  })
}
resource "azurerm_subnet" "challenge-subnet" {
  name                 = "challenge-subnet"
  resource_group_name  = azurerm_resource_group.challenge-rg.name
  virtual_network_name = azurerm_virtual_network.challenge-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}