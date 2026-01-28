variable "location" {
  type        = string
  description = "Azure region"
  default     = "uksouth"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "sandbox"
}

variable "networking_rg_name" {
  type        = string
  description = "Resource group name where VNets live"
  default     = "rg-platform-networking-sandbox"
}

variable "hub_vnet_name" {
  type        = string
  description = "Hub VNet name"
  default     = "vnet-hub-sandbox"
}

variable "hub_vnet_id" {
  type        = string
  description = "Hub VNet resource ID"
  default     = "/subscriptions/7b99d635-e1a4-4bdf-ab67-b6f98b73a423/resourceGroups/rg-platform-networking-sandbox/providers/Microsoft.Network/virtualNetworks/vnet-hub-sandbox"
}

variable "spokes" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefixes = list(string)
    }))
  }))

  description = "Map of spoke VNets to create"

  default = {
    "app" = {
      address_space = ["10.1.0.0/16"]
      subnets = {
        snet-app  = { address_prefixes = ["10.1.1.0/24"] }
        snet-data = { address_prefixes = ["10.1.2.0/24"] }
      }
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources"
  default = {
    env    = "sandbox"
    system = "azure-platform-foundation"
    owner  = "hassam"
  }
}
variable "subscription_id" {
  type = string
}