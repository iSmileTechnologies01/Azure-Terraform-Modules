# terraform-azurerm-loadbalancer

A terraform module to provide load balancers in Azure with the following
characteristics:

- Ability to specify `public` or `private` loadbalancer using: `var.type`.  Default is public.
- Specify subnet to use for the loadbalancer: `frontend_subnet_id`
- For `private` loadbalancer, specify the private ip address using`frontend_private_ip_address`
- Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`



Public loadbalancer example:

```hcl


module "mylb" {
  source  = "app.terraform.io/oneamerica/loadbalancer/azurerm"
  version = "1.0.0"
  resource_group_name                    = azurerm_resource_group.example.name
  type                                   = "private"
  frontend_subnet_id                     = module.network.vnet_subnets[0]
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.0.1.6"
  lb_sku                                 = "Standard"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }

  lb_probe = {
    http  = ["Tcp", "80", ""]
    http2 = ["Http", "1443", "/"]
  }

  tags = {
    cost-center = "12345"
    source      = "terraform"
  }
}

```
