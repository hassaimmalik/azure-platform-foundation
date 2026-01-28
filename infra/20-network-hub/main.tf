resource "azurerm_virtual_network" "hub" {
   name                = "vnet-hub-${var.env}"
  location            = var.location
  resource_group_name = var.networking_rg_name

  address_space = var.hub_vnet_address_space
  tags          = var.tags
}

resource "azurerm_subnet" "hub" {
  for_each = var.hub_subnets

  name                 = each.key
  resource_group_name  = var.networking_rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = each.value.address_prefixes
}