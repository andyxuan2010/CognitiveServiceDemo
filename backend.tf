terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
  backend "azurerm" {
    resource_group_name  = "PayAsYouGo"
    storage_account_name = "azgeneraluse"
    container_name       = "tfstate"
    key                  = "basf-demo.tfstate"
  }

}


provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
#data.azurerm_client_config.current.client_id
data "azurerm_subscriptions" "available" {}
#data.azurerm_subscriptions.available.subscriptions