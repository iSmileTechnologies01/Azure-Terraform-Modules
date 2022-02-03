variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = "Shared_Vnet"
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "CloudFoundation"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/27", "10.0.2.0/27", "10.0.3.0/28", "10.0.4.0/28", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["Core-Services_subnet1", "NGFW-Mgmt_subnet2", "Remote-Access_subnet3", "AD_subnet4", "Private-Endpoint_subnet3", "SIEM_subnet4"]
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)

  default = {
  }
}

variable "route_tables_ids" {
  description = "A map of subnet name to Route table ids"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    ENV = "test"
  }
}