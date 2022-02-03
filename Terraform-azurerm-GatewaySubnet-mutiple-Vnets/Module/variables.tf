variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = list(string)
  default     = ["Hub_VNet","Shared_VNet"]
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "ResourceGroupName"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.1.0.0/16"]
}
// VNET 2 address space
variable "address_space1" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.2.0.0/16"]
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
  default     = ["10.1.32.0/19", "10.1.64.0/18", "10.1.128.0/17"]
}
//VNET 2  address prefix
variable "subnet_prefixes1" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     =["10.2.0.0/21", "10.2.8.0/21", "10.2.16.0/20" , "10.2.32.0/19", "10.2.64.0/18", "10.2.128.0/17"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["FW-MGMT", "FW-Trust","FW-untrust"]
}
// vnet 2 subnet 

variable "subnet_names1" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["Core_Services ", "Remote_Access","Private_Endpoint", "NGFW_Mgmt","AD","SIEM"]
}
variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)
  default= {}    # do not remove this line
 
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
//VNET PEERING VARS




// variable "resource_group_names" {
//   type        = list(string)
//   description = "Names of both Resources groups of the respective virtual networks provided in list format"
// }

variable allow_cross_subscription_peering {
  description = "Boolean flag indicating if the peering is done across different subscriptions. Need to provide both Subscription ID's if this is set to true. Defaults to false."
  default     = false
}

variable "subscription_ids" {
  type        = list(string)
  description = "List of two subscription ID's provided in cause of allow_cross_subscription_peering set to true."
  default     = ["", ""]
}
variable "vnet_peering_names" {
  type        = list(string)
  description = "Name of the virtual network peerings to created in both virtual networks provided in list format."
  default = ["vnet_peer_1","vnet_peer_2"]
}

variable "allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false."
  default     = false
}

variable "allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false."
  default     = true
}

variable "allow_gateway_transit" {
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Must be set to false for Global VNET peering."
  default     = true
}

variable "use_remote_gateways" {
  description = "(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Defaults to false."
  default     = false
}

