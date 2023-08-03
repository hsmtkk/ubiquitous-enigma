provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  location = var.location
  name     = var.project
}