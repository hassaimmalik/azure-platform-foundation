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

variable "prefix" {
  type        = string
  description = "Short prefix used in names"
  default     = "platform"
}

variable "networking_rg_name" {
  type        = string
  description = "Resource group name where hub networking resources live"
  default     = "rg-platform-networking-sandbox"
}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "Hub VNet address space"
  default     = ["10.0.0.0/16"]
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
  description = "Hub subnets map"

  default = {
    AzureBastionSubnet = { address_prefixes = ["10.0.0.0/26"] }
    snet-shared        = { address_prefixes = ["10.0.1.0/24"] }
    snet-services      = { address_prefixes = ["10.0.2.0/24"] }

    snet-automation = { address_prefixes = ["10.0.50.0/24"] }
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