# terraform-azurerm-windows-vm-scale-set

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| azurerm | >= 2.44.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.44.0 |
| random | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage in Terraform 0.13
```hcl

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

module "scale-set-windows" {
  source  = "app.terraform.io/oneamerica/scale-set-windows/azurerm"
  version = "1.0.0"
  resource_group_name = "azurerm_resource_group.example.name" 
  location            = "canadacentral"
  vnet_name           = "vnet-demo-001"
  subnet_name         = "subnet1"
  winvmss_name        = ["testvmss"]
  vm_computer_name    = "websrv1"

  win_distro                         = "windows2019dc"
  instances_count                    = 2
  admin_username                     = "azureadmin"
  admin_password                     = "Password"
  enable_load_balancer               = false
  load_balancer_type                 = "public"
  load_balancer_health_probe_port    = 80
  load_balanced_port_list            = [80]
  encryption_at_host_enabled         = false
  os_disk_size_gb                    = 127
  additional_data_disks              = [10, 20]
  enable_autoscale_for_vmss          = true
  minimum_instances_count            = 2
  maximum_instances_count            = 5
  scale_out_cpu_percentage_threshold = 80
  scale_in_cpu_percentage_threshold  = 20

  nsg_inbound_rules = [
    {
      name                   = "https"
      destination_port_range = "443"
      source_address_prefix  = "*"
      destination_address_prefix  = "*"
    },
  ]

  tags = {
    Env = "dev"
  }
}
```
