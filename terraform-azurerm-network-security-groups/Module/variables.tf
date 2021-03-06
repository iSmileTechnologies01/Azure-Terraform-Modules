# Network Security Group definition
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "resourcegroupname"
}

variable "security_group_name" {
  description = "Network security group name"
  type        = string
  default     = "nsg"
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = map(string)
  default     = {}
}
variable "rules" {
  type = any
  default = "default"
}
variable "location" {
  description = "Location (Azure Region) for the network security group."
  # No default - if it's not specified, use the resource group location (see main.tf)
  type    = string
  default = ""
}

# Security Rules definition 

# Predefined rules   
variable "predefined_rules" {
  type    = any
  default = []
}

# Custom security rules
# [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
# All the fields are required.
variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = any
  default     = []
}

# source address prefix to be applied to all rules
variable "source_address_prefix" {
  type    = list(string)
  default = ["*"]

  # Example ["10.0.3.0/24"] or ["VirtualNetwork"]
}

# Destination address prefix to be applied to all rules not to a single rule
variable "destination_address_prefix" {
  type    = list(string)
  default = ["*"]

  # Example ["10.0.3.0/32","10.0.3.128/32"] or ["VirtualNetwork"] 
}

variable "source_application_security_group_ids" {
  description = "(Optional) A List of source Application Security Group IDs. Conflicted with `source_address_prefix`. Once assigned with `source_address_prefix`, it'll have a higher priority."
  type        = set(string)
  default     = []
}

variable "destination_application_security_group_ids" {
  description = "(Optional) A List of destination Application Security Group IDs. Conflicted with `destination_address_prefix`. Once assigned with `destination_address_prefix`, it'll have a higher priority."
  type        = set(string)
  default     = []
}

#####
# Diagnostics settings
#####

variable "diagnostics_enabled" {
  description = "Boolean flag which describes whether or not enable the diagnostics settings is enabled or not."
  default     = false
}

variable "diagnostics_map" {
  description = "contains the sa and eh details for operations diagnostics"
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "contains the log analytics workspace details for operations diagnostics"
  type        = string
  default     = null
}

variable "opslogs_retention_period" {
  description = "Number of days to keep operations logs inside storage account"
  default     = 60
}