
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
  subscription_id = "330fc8ce-77f6-4dae-85e4-cd286dcc11a2"
  client_id       = "8f7d4d33-d884-4187-b9b3-1795217c5e33"
  client_secret   = "Hg1v5FE.Q-1pu7m5goo1IP-JZr9i_O2g_b"
  tenant_id       = "1701d283-ad46-4058-ae88-6e696b83aae7"
}