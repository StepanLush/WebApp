provider "azurerm" {
  features {
    /*resource_group {
      prevent_deletion_if_contains_resources = false
    }*/
  }
  # subscription_id = var.subscription_id
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
}


terraform {
  backend "azurerm" {
    resource_group_name  = "state-rg"
    storage_account_name = "stagestorage738"
    container_name       = "stage-container"
    key                  = "terraform.tfstate"
  }
}
