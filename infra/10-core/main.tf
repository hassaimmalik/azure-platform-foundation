locals {
  # These are ORGANISATIONAL buckets (containers).
  # Other stacks (network/governance/etc.) will deploy INTO these RGs.
  resource_groups = {
    core       = "rg-${var.prefix}-core-${var.env}"
    management = "rg-${var.prefix}-management-${var.env}"
    security   = "rg-${var.prefix}-security-${var.env}"
    networking = "rg-${var.prefix}-networking-${var.env}"
  }
}

resource "azurerm_resource_group" "platform" {
  for_each = local.resource_groups

  name     = each.value
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.prefix}-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform["management"].name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

resource "azurerm_monitor_action_group" "ag" {
  name                = "ag-${var.prefix}-${var.env}"
  resource_group_name = azurerm_resource_group.platform["management"].name
  short_name          = "ag${var.env}"

  email_receiver {
    name          = "primary"
    email_address = var.alert_email
  }

  tags = var.tags
}
