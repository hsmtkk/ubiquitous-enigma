terraform {
  backend "azurerm" {
    resource_group_name  = "ubiquitous-enigma-backend"
    storage_account_name = "terraformubiquitous"
    container_name       = "tfstate"
    key                  = "tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
