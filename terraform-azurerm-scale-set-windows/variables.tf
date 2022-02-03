###
# Load Balancer
###

variable "location" {
  description = "Location the resource"
}

variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "vnet_name" {
  description = "the name the virtual in which the virtual machine scale will reside"
}

variable "additional_data_disk_capacity_list" {
  default = []
}

variable "subnet_name" {
  description = "the name of subnet where the virtaul machine scale set will be created. "
}

variable "load_balancer_exist" {
  description = "Boolean flag which describes  whether a Loadbalncer is already existing or it has to be created."
  default     = false
}

variable "load_balancer_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  default     = "Standard"
}

variable "enable_load_balancer" {
  description = "Controls if public load balancer should be created"
  default     = true
}

variable "load_balancer_type" {
  description = "Controls the type of load balancer should be created. Possible values are public and private"
  default     = "private"
}

variable "enable_lb_nat_pool" {
  description = "If enabled load balancer nat pool will be created for SSH if flavor is linux and for winrm if flavour is windows"
  default     = false
}

variable "nat_pool_frontend_ports" {
  description = "Optional override for default NAT ports"
  type        = list(number)
  default     = [50000, 50119]
}

variable "backend_port" {
  description = ""
  default     = 3389
}

variable "load_balancer_health_probe_port" {
  description = "Port on which the Probe queries the backend endpoint. Default `80`"
  default     = 80
}

variable "load_balanced_port_list" {
  description = "List of ports to be forwarded through the load balancer to the VMs"
  type        = list(number)
  default     = []
}

variable "health_probe_id" {
  description = "The id of the load balancer health probe to be used to monitor the health checks of backend pool VM's"
  default     = null
}

variable "backend_pool_exist" {
  description = "Boolean flag which backend pool already exist or not."
  default     = false
}

variable "load_balancer_backend_address_pool_ids" {
  description = "A list of Backend Address Pools ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to."
  type        = list(string)
  default     = []
}

variable "load_balancer_inbound_nat_rules_ids" {
  description = "A list of NAT Rule ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to."
  type        = list(string)
  default     = []
}

variable "private_ip_address_allocation" {
  description = "The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static."
  default     = "Dynamic"
}

variable "lb_private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer."
  default     = null
}

variable "nsg_enabled" {
  description = "Boolean flag which describes whether or not enable the Network security group."
  default     = true
}
variable "nsg_inbound_rules" {
  description = "List of network rules to apply to network interface."
  default     = []
}

variable "assign_public_ip_to_each_vm_in_vmss" {
  description = "Create a virtual machine scale set that assigns a public IP address to each VM"
  default     = false
}

###
# scale Set
###
variable "winvmss_count" {
  description = "The number of scale set to be deployed"
  default     = 1
}

variable "winvmss_name" {
  description = "Specifies the name of the virtual machine scale set resource"
  default     = []
}

variable "vm_computer_name" {
  description = "Specifies the name of the virtual machine inside the VM scale set"
  default     = ""
}

variable "sku" {
  description = "The Virtual Machine SKU for the Scale Set, Default is Standard_A2_V2"
  default     = "Standard_A2_v2"
}

variable "instances_count" {
  description = "The number of Virtual Machines in the Scale Set."
  default     = 1
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}

variable "license_type" {
  description = "Specifies the type of on-premise license which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  default     = "None"
}

variable "single_placement_group" {
  description = "Allow to have cluster of 100 VMs only"
  default     = true
}

variable "overprovision" {
  description = "Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You're not billed for these over-provisioned VM's and they don't count towards the Subscription Quota. Defaults to true."
  default     = false
}

variable "upgrade_mode" {
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic"
  default     = "Manual"
}

variable "priority" {
  description = "Specfies the priority of the virtual machine. Posssible values are `regular` an `Spot`. Defaults to `Regular`. Changing this forces a new resourec to be created."
  default     = "Regular"
}

variable "max_bid_price" {
  description = "The maximum price youre willing to pay for the vitual machine, in US Dollard; which must be greater tha the current spot price. If this bid price falls below the current spot price the virtual machine will be evicted using the `evction_policy`. Defaults to `-1`, which means that the virtual machine should not be evicted for the price reason."
  default     = "-1"
}

variable "eviction_policy" {
  description = "Specifies what should happen when the virtual machine is evicted for the price reason when using the spot instance. At this time only supported value is `Deallocate`. Changing this forces a new resource to be created."
  default     = "Deallocate"
}

variable "provision_vm_agent" {
  description = "Boolean flag which describes whether to provision the VM agent or not."
  default     = false
}

variable "availability_zone_balance" {
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones?"
  default     = true
}

variable "zones" {
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
  default     = [1, 2]
}

variable "enable_automatic_updates" {
  description = "Boolean flag to determine whether or not enable the automatic upadtes."
  default     = false
}

variable "encryption_at_host_enabled" {
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = true
}

variable "scale_in_policy" {
  description = "value"
  default     = "Default"
}

variable "additional_capabilities_ultra_ssd_enabled" {
  description = "Should Ultra SSD disk be enabled for this Virtual Machine?"
  default     = false
}

variable "boot_diagnostics_enabled" {
  description = "Boolean flag which describes whether or not enable the boot diagnostics setting for the virtual machine."
  default     = false
}

variable "boot_diagnostics_storage_account_uri" {
  description = "The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files."
  default     = ""
}

variable "source_image_id" {
  description = "The ID of an Image which each Virtual Machine in this Scale Set should be based on"
  default     = null
}

variable "custom_image" {
  description = "Proive the custom image to this module if the default variants are not sufficient"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "win_distro_list" {
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    windows2012r2dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2012-R2-Datacenter"
      version   = "latest"
    }

    windows2016dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    }

    windows2019dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    mssql2017exp = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2016"
      sku       = "Express"
      version   = "latest"
    }
  }
}

variable "win_distro" {
  type        = string
  default     = "windows2019dc"
  description = "Variable to pick an OS flavour for Windows based VMSS possible values include: winserver, wincore, winsql"
}

variable "additional_unattend_content_windows_setting" {
  description = "Specifies the name of the setting to which the content applies. Possible values are: `FirstLogonCommands` and `AutoLogon`."
  default     = "FirstLogonCommands"
}

variable "additional_unattend_content_windows_content" {
  description = "Specifies the base-64 encoded XML formatted content that is added to the unattend.xml file for the specified path and component."
  default     = ""
}

variable "identity_types" {
  description = "The list of types of Managed identity which should be assigned to the virtual machine. Possible values are `systemassigned`, `UserAssigned` and `SustemAssigned,UserAssigned`."
  default     = [""]
}

variable "identity_identity_ids" {
  description = "A list of list of User managed identity ID's which should be assigned to the virtual machine."
  type        = list(list(string))
  default     = [null]
}

variable "os_disk_size_gb" {
  description = "The Size of the Internal OS Disk in GB"
  default     = 40
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite."
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "StandardSSD_LRS"
}

variable "os_disk_encryption_set_id" {
  description = "The ID of the Disk encryption set which should be used to encrypt the OS disk. `NOTE: The Disk encryption set must have the `READER` role assignmnet scoped on the key vault- in addition to an access policy to the key vault`."
  default     = null
}

variable "diff_disk_settings_option" {
  description = "Specifies the Ephemeral disk settings for the OS Disk. At this time the only possible value is `local`. Changing this forces a new resource to be created."
  default     = ""
}

variable "additional_data_disks" {
  description = "Adding additional disks capacity to add each instance (GB)"
  type        = list(number)
  default     = []
}

variable "additional_data_disks_storage_account_type" {
  description = "The Type of Storage Account which should back this Data Disk. Possible values include Standard_LRS, StandardSSD_LRS, Premium_LRS and UltraSSD_LRS."
  default     = "Standard_LRS"
}

variable "plan_name" {
  description = "Specifies the name of the image from the marketplace."
  default     = ""
}

variable "plan_publisher" {
  description = "Specifies the publisher of the image."
  default     = ""
}

variable "plan_product" {
  description = "Specifies the product of the image from the marketplace."
  default     = ""
}

variable "dns_servers" {
  description = "List of dns servers to use for network interface"
  default     = []
}

variable "enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Defaults to false"
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  default     = false
}

variable "secret_key_vault_id" {
  description = "The ID of the key vault from where all the certificates or secrets are stored. This can be source from `id` filed from the `azurerm_key_vault` resource."
  default     = ""
}

variable "certificate_url" {
  description = "The Secret URL of the Key vault certificate.This can be sourced from the `secret_url` field within the `azurerm_key_vault_certificate` resource."
  default     = ""
}

variable "windows_certificate_store" {
  description = "The certificate store on the windows virtual machine where the certificate should be added."
  default     = ""
}

variable "enable_automatic_instance_repair" {
  description = "Should the automatic instance repair be enabled on this Virtual Machine Scale Set?"
  default     = false
}

variable "grace_period" {
  description = "Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed."
  default     = "PT30M"
}

variable "winrm_listener_protocol" {
  description = "Specifies the protocol of listener. Possible values are `Http` or `Https`."
  default     = "Http"
}

variable "winrm_listener_certificate_url" {
  description = "The ID of the Key Vault Secret which contains the encrypted Certificate which should be installed on the Virtual Machine. This certificate must also be specified in the vault_certificates block within the os_profile_secrets block."
  default     = ""
}

variable "terminate_notification_enabled" {
  description = "Should the terminate notification be enabled on this Virtual Machine Scale Set? Defaults to `false`."
  default     = false
}

###
# Auto scaling
###

variable "enable_autoscale_for_vmss" {
  description = "Manages a AutoScale Setting which can be applied to Virtual Machine Scale Sets"
  default     = false
}

variable "minimum_instances_count" {
  description = "The minimum number of instances for this resource. Valid values are between 0 and 1000"
  default     = null
}

variable "maximum_instances_count" {
  description = "The maximum number of instances for this resource. Valid values are between 0 and 1000"
  default     = ""
}

variable "scale_out_cpu_percentage_threshold" {
  description = "Specifies the threshold % of the metric that triggers the scale out action."
  default     = "80"
}

variable "scale_in_cpu_percentage_threshold" {
  description = "Specifies the threshold of the metric that triggers the scale in action."
  default     = "20"
}

variable "scaling_action_instances_number" {
  description = "The number of instances involved in the scaling action"
  default     = "1"
}

###
# Log analytics workspace
###

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "auto_upgrade_minor_version" {
  description = "Boolaen flag which describes whether to automatically upgarde the minor patch versions"
  default     = false
}

###
# Monitoring diagnostics
###

variable "diag_storage_account_name" {
  description = "The name of the storage account to store diagnostics logs"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
