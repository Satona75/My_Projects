terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 4.35.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-tfstate"
      storage_account_name = "tfstate23864"
      container_name       = "tfstate"
      key                  = "satona.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "88888d09-c09d-4578-ab0d-731f655d24ef"
}
