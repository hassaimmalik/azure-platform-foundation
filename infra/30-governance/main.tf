data "azurerm_subscription" "current" {}

# --------------------
# RBAC – Identity layer
# --------------------

resource "azuread_group" "platform_admins" {
  display_name     = "Platform-Admins-${var.env}"
  security_enabled = true
}

resource "azuread_group" "platform_readers" {
  display_name     = "Platform-Readers-${var.env}"
  security_enabled = true
}

resource "azurerm_role_assignment" "admins" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.platform_admins.object_id
}

resource "azurerm_role_assignment" "readers" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.platform_readers.object_id
}

# --------------------
# Azure Policy – Guardrails
# --------------------

resource "azurerm_policy_definition" "require_tags" {
  name         = "require-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require mandatory tags"

  policy_rule = jsonencode({
    "if" = {
      "anyOf" = [
        for t in var.required_tags : {
          "field"  = "tags['${t}']"
          "exists" = "false"
        }
      ]
    }
    "then" = { "effect" = "audit" }
  })
}



resource "azurerm_subscription_policy_assignment" "require_tags" {
  name                 = "require-tags-assignment"
  subscription_id      = data.azurerm_subscription.current.id # ✅ full /subscriptions/<guid>
  policy_definition_id = azurerm_policy_definition.require_tags.id
}

