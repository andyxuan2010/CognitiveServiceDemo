terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
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