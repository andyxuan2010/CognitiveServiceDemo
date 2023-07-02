
resource "azurerm_resource_group" "challenge-rg" {
  name     = "challenge-resources"
  location = "West Europe"
}
resource "azurerm_virtual_network" "challenge-vnet" {
  name                = "challenge-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.challenge-rg.location
  resource_group_name = azurerm_resource_group.challenge-rg.name
}
resource "azurerm_subnet" "challenge-subnet" {
  name                 = "challenge-subnet"
  resource_group_name  = azurerm_resource_group.challenge-rg.name
  virtual_network_name = azurerm_virtual_network.challenge-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}