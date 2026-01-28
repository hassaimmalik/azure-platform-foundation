variable "location" {
  type        = string
  description = "Azure region for bootstrap resources"
  default     = "uksouth"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for bootstrap resources"
  default     = "rg-platform-bootstrap"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix for the Terraform state storage account (must result in <=24 chars after suffix)"
  default     = "sttfstate"
}

variable "container_name" {
  type        = string
  description = "Blob container name for Terraform state"
  default     = "tfstate"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to bootstrap resources"
  default = {
    env    = "sandbox"
    system = "azure-platform-foundation"
    owner  = "hassam"
  }
}
variable "storage_container_name" {
  type        = string
  description = "The name of the storage container in which to store the tfstate file"
  default     = "tfstate"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for deployments"
}
