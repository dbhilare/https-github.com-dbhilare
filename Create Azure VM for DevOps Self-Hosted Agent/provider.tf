terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.115.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e035c6a6-7703-4c41-8736-d7668db3a49b"
}