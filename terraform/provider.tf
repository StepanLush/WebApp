provider "azurerm" {
  features {
    /*resource_group {
      prevent_deletion_if_contains_resources = false
    }*/
  }
  subscription_id = var.subscription_id
}


terraform {
  backend "azurerm" {
    resource_group_name  = "state-rg"
    storage_account_name = "stagestorage738"
    container_name       = "stage-container"
    key                  = "terraform.tfstate"
  }
}
