variable "location" {
  type        = string
  description = "Azure region for core resources"
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

variable "alert_email" {
  type        = string
  description = "Email address for Azure Monitor Action Group alerts"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources"
  default = {
    env        = "sandbox"
    system     = "azure-platform-foundation"
    owner      = "hassam"
    managed_by = "terraform"
  }
}

variable "subscription_id" {
  type = string
}