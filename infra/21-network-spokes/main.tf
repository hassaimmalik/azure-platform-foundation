resource "azurerm_virtual_network" "spoke" {
  for_each = var.spokes

  name                = "vnet-spoke-${each.key}-${var.env}"
  location            = var.location
  resource_group_name = var.networking_rg_name

  address_space = each.value.address_space
  tags          = var.tags
}

resource "azurerm_subnet" "spoke" {
  for_each = merge([
    for spoke_key, spoke in var.spokes : {
      for subnet_name, subnet in spoke.subnets :
      "${spoke_key}/${subnet_name}" => {
        spoke_key        = spoke_key
        subnet_name      = subnet_name
        address_prefixes = subnet.address_prefixes
      }
    }
  ]...)

  name                 = each.value.subnet_name
  resource_group_name  = var.networking_rg_name
  virtual_network_name = azurerm_virtual_network.spoke[each.value.spoke_key].name
  address_prefixes     = each.value.address_prefixes
}

# Peering: Spoke -> Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = var.spokes

  name                      = "peer-spoke-${each.key}-to-hub-${var.env}"
  resource_group_name       = var.networking_rg_name
  virtual_network_name      = azurerm_virtual_network.spoke[each.key].name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Peering: Hub -> Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = var.spokes

  name                      = "peer-hub-to-spoke-${each.key}-${var.env}"
  resource_group_name       = var.networking_rg_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke[each.key].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
