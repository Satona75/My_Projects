terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.47.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
}
  backend "azurerm" {
}
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
 }
