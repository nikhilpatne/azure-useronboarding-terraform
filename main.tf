terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
client_id       =   var.client_id
client_secret   =   var.client_secret
subscription_id =   var.subscription_id
tenant_id       =   var.tenant_id
  
}


resource "azurerm_resource_group" "example" {
  name     = "nikhilrgg"
  location = "eastus"
}



variable "client_id" {
    description =   "Client ID (APP ID) of the application"
    type        =   string
}

variable "client_secret" {
    description =   "Client Secret (Password) of the application"
    type        =   string
}

variable "subscription_id" {
    description =   "Subscription ID"
    type        =   string
}

variable "tenant_id" {
    description =   "Tenant ID"
    type        =   string
}
