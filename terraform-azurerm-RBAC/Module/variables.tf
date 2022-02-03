variable "tags" {
  type    = map(any)
  default = {}
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "resource_group_id" {
  type    = string
  default = ""
}

variable "azurerm_subscription_id" {
  type    = string
  default = ""
}

variable "mg_group_names" {
  default = ""
}

variable "aad_group_names_rg" {
  type    = list(string)
  default = []
}

variable "aad_group_names_mg" {
  type    = list(string)
  default = []
}

variable "aad_group_names_sub" {
  type    = list(string)
  default = []
}

variable "role_mapping_rg" {
  type    = map(string)
  default = {}
}

variable "role_mapping_mg" {
  type    = map(string)
  default = {}
}

variable "role_mapping_sub" {
  type    = map(string)
  default = {}
}


variable "prevent_duplicate_names" {
  type    = bool
  default = true
}
