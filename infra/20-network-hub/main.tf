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

resource "azurerm_network_security_rule" "allow_ssh_from_my_ip" {
  name                        = "Allow-SSH-From-My-IP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "82.37.87.249/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.networking_rg_name
  network_security_group_name = azurerm_network_security_group.nsg_automation.name
}

resource "azurerm_network_security_rule" "allow_awx_ui_from_my_ip" {
  name                        = "Allow-AWX-UI-From-My-IP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8052"
  source_address_prefix       = "82.37.87.249/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.networking_rg_name
  network_security_group_name = azurerm_network_security_group.nsg_automation.name
}
