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
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
    subscription_id = "88888d09-c09d-4578-ab0d-731f655d24ef"
  
}