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
    use_cli              = true                                    
    use_azuread_auth     = true                                    
    tenant_id            = "9e2fa0ed-a2ae-45f7-8ac9-302a462fcd0e"  
    storage_account_name = "stbazi0r"                              
    container_name       = "tfstate"                               
    key                  = "observability-dev"               
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
    subscription_id = "88888d09-c09d-4578-ab0d-731f655d24ef"
  
 }
