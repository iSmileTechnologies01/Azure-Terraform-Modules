variable "address_space" {
  type      = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.3.0.0/16"]
}
variable "address_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.3.0.0/19"]
}
variable "location" {
    type = string
    description = "Azure location of storage account environment"
    default = "westus2"
}
