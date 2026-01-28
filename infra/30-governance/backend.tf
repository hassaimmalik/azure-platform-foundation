terraform {
  backend "azurerm" {
    resource_group_name  = "rg-platform-bootstrap"
    storage_account_name = "sttfstateslvr8j"
    container_name       = "tfstate"
    key                  = "30-governance.tfstate"
  }
}
