output "resource_groups" {
  value = { for k, rg in azurerm_resource_group.platform : k => rg.name }
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "action_group_id" {
  value = azurerm_monitor_action_group.ag.id
}
