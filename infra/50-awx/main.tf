# Existing hub automation subnet
data "azurerm_resource_group" "rg_networking" {
  name = var.networking_rg_name
}

data "azurerm_virtual_network" "vnet_hub" {
  name                = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.rg_networking.name
}

data "azurerm_subnet" "snet_automation" {
  name                 = "snet-automation"
  virtual_network_name = data.azurerm_virtual_network.vnet_hub.name
  resource_group_name  = data.azurerm_resource_group.rg_networking.name
}

resource "azurerm_public_ip" "pip_awx" {
  name                = "pip-awx-${var.env}"
  location            = var.location
  resource_group_name = var.management_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_awx" {
  name                = "nic-awx-${var.env}"
  location            = var.location
  resource_group_name = var.management_rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.snet_automation.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_awx.id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm_awx" {
  name                = "vm-awx-${var.env}"
  location            = var.location
  resource_group_name = var.management_rg_name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.nic_awx.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = merge(var.tags, {
    role = "awx"
  })
}

output "awx_public_ip" {
  value = azurerm_public_ip.pip_awx.ip_address
}

output "awx_private_ip" {
  value = azurerm_network_interface.nic_awx.private_ip_address
}
