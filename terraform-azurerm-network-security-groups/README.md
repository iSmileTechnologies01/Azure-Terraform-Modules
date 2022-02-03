# terraform-azurerm-network-security-group


## Create a network security group

This Terraform module deploys a Network Security Group (NSG) in Azure and optionally attach it to the specified vnets.

This module is a complement to the [Azure Network]module. Use the network_security_group_id from the output of this module to apply it to a subnet in the Azure Network module.

This module includes a a set of pre-defined rules for commonly used protocols (for example HTTP or ActiveDirectory) that can be used directly in their corresponding modules or as independent rules.

## Usage with the generic module in Terraform 0.13

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules.

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "EastUS2"
}

module "network-security-group" {
  source  = "app.terraform.io/oneamerica/network-security-groups/azurerm"
  version = "1.0.0"  
  resource_group_name   = azurerm_resource_group.example.name
  location              = "EastUS" # Optional; if not provided, will use Resource Group location
  security_group_name   = "nsg"
  source_address_prefix = ["10.0.3.0/24"]
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    },
    {
      name              = "LDAP"
      source_port_range = "1024-1026"
    }
  ]

  custom_rules = [
    {
      name                   = "myhttp"
      priority               = "200"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "8080"
      description            = "description-myhttp"
    }
  ]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}
```