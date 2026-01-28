variable "env" {
  type    = string
  default = "sandbox"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "required_tags" {
  type    = list(string)
  default = ["env", "system", "owner"]
}
variable "subscription_id" {
  type = string
}