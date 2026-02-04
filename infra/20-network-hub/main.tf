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

resource "azurerm_network_security_group" "nsg_automation" {
  name                = "nsg-snet-automation"
  location            = var.location
  resource_group_name = var.networking_rg_name
}

resource "azurerm_subnet_network_security_group_association" "assoc_automation" {
  subnet_id                 = azurerm_subnet.hub["snet-automation"].id
  network_security_group_id = azurerm_network_security_group.nsg_automation.id
}
