variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "env" {
  type    = string
  default = "sandbox"
}

variable "networking_rg_name" {
  type    = string
  default = "rg-platform-networking-sandbox"
}

variable "management_rg_name" {
  type    = string
  default = "rg-platform-management-sandbox"
}

variable "hub_vnet_name" {
  type    = string
  default = "vnet-hub-sandbox"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

# IMPORTANT: this path must exist on the GitHub runner.
# We'll handle that by generating the key in the workflow and writing it to a file.

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "tags" {
  type = map(string)
  default = {
    env    = "sandbox"
    system = "azure-platform-foundation"
    owner  = "hassam"
  }
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Admin SSH public key for the AWX VM"
}

