# Confirm the RG exists (created by 10-core) and get its details
data "azurerm_resource_group" "workload" {
  name = var.workload_rg_name
}

# Get the subnet (created by 21-network-spokes)
data "azurerm_subnet" "target" {
  name                 = var.subnet_name
  virtual_network_name = var.spoke_vnet_name
  resource_group_name  = var.networking_rg_name
}

# SSH keypair for the VM (sandbox-safe; in prod you'd store this in Key Vault / use existing)
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-ansible-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.workload.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.target.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-ansible-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.workload.name
  size                = "Standard_B1s"

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}
