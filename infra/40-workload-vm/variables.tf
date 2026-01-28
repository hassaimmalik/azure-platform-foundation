variable "location" {
  type    = string
  default = "uksouth"
}

variable "env" {
  type    = string
  default = "sandbox"
}

variable "workload_rg_name" {
  type    = string
  default = "rg-platform-core-sandbox"
}

variable "networking_rg_name" {
  type    = string
  default = "rg-platform-networking-sandbox"
}

variable "spoke_vnet_name" {
  type    = string
  default = "vnet-spoke-app-sandbox"
}

variable "subnet_name" {
  type    = string
  default = "snet-app"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "tags" {
  type = map(string)

  default = {
    env    = "sandbox"
    system = "azure-platform-foundation"
    owner  = "hassam"
  }
}

variable "subscription_id" {
  type = string
}
