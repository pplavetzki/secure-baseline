# Update the variables in the BACKEND block to refrence the 
# storage account created out of band for TF statemanagement.

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.86.0"
    }

  }

  backend "azurerm" {}

}

provider "azurerm" {
    skip_provider_registration  = true
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
}

