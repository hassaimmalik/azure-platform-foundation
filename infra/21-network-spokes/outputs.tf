output "spoke_vnet_ids" {
  value = { for k, v in azurerm_virtual_network.spoke : k => v.id }
}

output "spoke_vnet_names" {
  value = { for k, v in azurerm_virtual_network.spoke : k => v.name }
}

output "spoke_subnet_ids" {
  value = { for k, s in azurerm_subnet.spoke : k => s.id }
}
