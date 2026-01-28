output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "hub_subnet_ids" {
  value = { for k, s in azurerm_subnet.hub : k => s.id }
}
