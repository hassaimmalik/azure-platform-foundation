provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {

}

resource "azurerm_resource_group" "bootstrap" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage account names must be globally unique and lowercase, 3-24 chars
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  storage_account_name = lower(replace("${var.storage_account_name_prefix}${random_string.suffix.result}", "-", ""))
}

resource "azurerm_storage_account" "tfstate" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.bootstrap.name
  location                 = azurerm_resource_group.bootstrap.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Good defaults for state storage
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}