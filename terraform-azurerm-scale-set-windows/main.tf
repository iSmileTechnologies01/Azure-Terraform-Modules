###
# Local
###
locals {
  nsg_inbound_rules = { for idx, security_rule in var.nsg_inbound_rules : security_rule.name => {
    idx : idx,
    security_rule : security_rule,
    }
  }
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "random_password" "passwd" {
  count       = var.admin_password == null ? 1 : 0
  length      = 8
  min_upper   = 2
  min_lower   = 4
  min_numeric = 2
  special     = false
}

###
# Public IP for Load Balancer
###
resource "azurerm_public_ip" "pip" {
  count               = var.enable_load_balancer == true && var.load_balancer_type == "public" ? 1 : 0
  name                = lower("pip-${var.winvmss_name[count.index]}-${coalesce(var.location, data.azurerm_resource_group.vmss.location)}")
  location            = coalesce(var.location, data.azurerm_resource_group.vmss.location)
  resource_group_name = data.azurerm_resource_group.vmss.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

###
# External Load Balancer with Public IP
###
resource "azurerm_lb" "vmsslb" {
  count               = var.enable_load_balancer ? 1 : 0
  name                = var.load_balancer_type == "public" ? lower("lbext-${var.winvmss_name[count.index]}-${coalesce(var.location, data.azurerm_resource_group.vmss.location)}") : lower("lbint-${var.winvmss_name[count.index]}-${coalesce(var.location, data.azurerm_resource_group.vmss.location)}")
  location            = coalesce(var.location, data.azurerm_resource_group.vmss.location)
  resource_group_name = data.azurerm_resource_group.vmss.name
  sku                 = var.load_balancer_sku
  tags                = local.tags

  frontend_ip_configuration {
    name                          = var.load_balancer_type == "public" ? lower("lbext-frontend-${var.winvmss_name[count.index]}") : lower("lbint-frontend-${var.winvmss_name[count.index]}")
    public_ip_address_id          = var.enable_load_balancer == true && var.load_balancer_type == "public" ? azurerm_public_ip.pip[count.index].id : null
    private_ip_address_allocation = var.load_balancer_type == "private" ? var.private_ip_address_allocation : null
    private_ip_address            = var.load_balancer_type == "private" && var.private_ip_address_allocation == "Static" ? var.lb_private_ip_address : null
    subnet_id                     = var.load_balancer_type == "private" ? data.azurerm_subnet.subnet.id : null
  }
}

###
# Backend address pool for Load Balancer
###
resource "azurerm_lb_backend_address_pool" "bepool" {
  count               = var.enable_load_balancer ? 1 : 0
  name                = lower("lbe-backend-pool-${var.winvmss_name[count.index]}")
  resource_group_name = data.azurerm_resource_group.vmss.name
  loadbalancer_id     = azurerm_lb.vmsslb[count.index].id
}

###
# Load Balancer NAT pool
###
resource "azurerm_lb_nat_pool" "natpol" {
  count                          = var.enable_load_balancer && var.enable_lb_nat_pool ? 1 : 0
  name                           = lower("lb-nat-pool-${var.winvmss_name[count.index]}-${coalesce(var.location, data.azurerm_resource_group.vmss.location)}")
  resource_group_name            = data.azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmsslb.0.id
  protocol                       = "Tcp"
  frontend_port_start            = var.nat_pool_frontend_ports[0]
  frontend_port_end              = var.nat_pool_frontend_ports[1]
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = azurerm_lb.vmsslb.0.frontend_ip_configuration.0.name
}

###
# Health Probe for resources
###
resource "azurerm_lb_probe" "lbp" {
  count               = var.enable_load_balancer ? 1 : 0
  name                = lower("lb-probe-port-${var.load_balancer_health_probe_port}-${var.winvmss_name[count.index]}")
  resource_group_name = data.azurerm_resource_group.vmss.name
  loadbalancer_id     = azurerm_lb.vmsslb[count.index].id
  port                = var.load_balancer_health_probe_port
}


###
# Load Balancer Rules
###
resource "azurerm_lb_rule" "lbrule" {
  count                          = var.enable_load_balancer ? length(var.load_balanced_port_list) : 0
  name                           = format(lower("lb-rule-%s-${var.winvmss_name[count.index]}"), count.index + 1)
  resource_group_name            = data.azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmsslb[0].id
  probe_id                       = azurerm_lb_probe.lbp[0].id
  protocol                       = "Tcp"
  frontend_port                  = tostring(var.load_balanced_port_list[count.index])
  backend_port                   = tostring(var.load_balanced_port_list[count.index])
  frontend_ip_configuration_name = azurerm_lb.vmsslb[0].frontend_ip_configuration.0.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bepool[0].id
}

###
# Network security group for Virtual Machine Network Interface
###
resource "azurerm_network_security_group" "nsg" {
  count               = var.nsg_enabled ? 1 : 0
  name                = lower("nsg-${var.winvmss_name[count.index]}-${coalesce(var.location, data.azurerm_resource_group.vmss.location)}")
  resource_group_name = data.azurerm_resource_group.vmss.name
  location            = coalesce(var.location, data.azurerm_resource_group.vmss.location)
  tags                = local.tags
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each                    = local.nsg_inbound_rules
  name                        = each.key
  priority                    = 100 * (each.value.idx + 1)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.security_rule.destination_port_range
  source_address_prefix       = each.value.security_rule.source_address_prefix
  destination_address_prefix  = each.value.security_rule.destination_address_prefix
  description                 = "Inbound_Port_${each.value.security_rule.destination_port_range}"
  resource_group_name         = data.azurerm_resource_group.vmss.name
  network_security_group_name = element(concat(azurerm_network_security_group.nsg.*.name, [""]), 0)
  depends_on                  = [azurerm_network_security_group.nsg]
}

###
# windows virtual machine scale sets
###

resource "azurerm_windows_virtual_machine_scale_set" "az_vm_scale_set" {
  count                      = var.winvmss_count
  name                       = format("vmss-%s", element(var.winvmss_name, count.index))
  computer_name_prefix       = format("%s%s", lower(replace(var.vm_computer_name, "/[[:^alnum:]]/", "")), count.index + 1)
  resource_group_name        = data.azurerm_resource_group.vmss.name
  location                   = coalesce(var.location, data.azurerm_resource_group.vmss.location)
  sku                        = var.sku
  instances                  = var.instances_count
  admin_password             = var.admin_password == null ? random_password.passwd[count.index].result : var.admin_password
  admin_username             = var.admin_username
  license_type               = var.license_type
  single_placement_group     = var.single_placement_group
  overprovision              = var.overprovision
  upgrade_mode               = var.upgrade_mode
  priority                   = var.priority
  max_bid_price              = var.priority == "Spot" ? var.max_bid_price : null
  eviction_policy            = var.priority == "Spot" ? var.eviction_policy : null
  health_probe_id            = var.load_balancer_exist == false && var.enable_load_balancer && var.upgrade_mode == "Automatic" || var.upgrade_mode == "Rolling" ? azurerm_lb_probe.lbp[0].id : var.health_probe_id
  provision_vm_agent         = var.provision_vm_agent
  zone_balance               = var.availability_zone_balance
  zones                      = var.zones
  enable_automatic_updates   = var.enable_automatic_updates
  encryption_at_host_enabled = var.encryption_at_host_enabled
  scale_in_policy            = var.scale_in_policy

  tags = local.tags

  additional_capabilities {
    ultra_ssd_enabled = var.additional_capabilities_ultra_ssd_enabled
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled == true ? [1] : []

    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  source_image_id = var.source_image_id != null ? var.source_image_id : null

  dynamic "source_image_reference" {
    for_each = var.source_image_id != null ? [] : [1]
    content {
      publisher = var.custom_image != null ? var.custom_image["publisher"] : var.win_distro_list[lower(var.win_distro)]["publisher"]
      offer     = var.custom_image != null ? var.custom_image["offer"] : var.win_distro_list[lower(var.win_distro)]["offer"]
      sku       = var.custom_image != null ? var.custom_image["sku"] : var.win_distro_list[lower(var.win_distro)]["sku"]
      version   = var.custom_image != null ? var.custom_image["version"] : var.win_distro_list[lower(var.win_distro)]["version"]
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.additional_unattend_content_windows_content != "" ? [1] : []

    content {
      content = var.additional_unattend_content_windows_content
      setting = var.additional_unattend_content_windows_setting
    }
  }

  dynamic "identity" {
    for_each = element(var.identity_types, count.index) != "" ? [1] : []

    content {
      type         = element(var.identity_types, count.index)
      identity_ids = element(var.identity_types, count.index) == "UserAssigned" ? element(var.identity_identity_ids, count.index) : null
    }
  }

  dynamic "os_disk" {
    for_each = var.os_disk_caching != "" ? [1] : []

    content {
      caching                   = var.os_disk_caching
      storage_account_type      = var.os_disk_storage_account_type
      disk_size_gb              = var.os_disk_size_gb
      disk_encryption_set_id    = var.os_disk_encryption_set_id
      write_accelerator_enabled = var.os_disk_storage_account_type == "Premium_LRS" ? true : false

      dynamic "diff_disk_settings" {
        for_each = var.diff_disk_settings_option != "" ? [1] : []

        content {
          option = var.diff_disk_settings_option
        }
      }
    }
  }

  dynamic "data_disk" {
    for_each = var.additional_data_disks

    content {
      lun                  = data_disk.key
      disk_size_gb         = data_disk.value
      caching              = "ReadWrite"
      storage_account_type = var.additional_data_disks_storage_account_type
    }
  }

  dynamic "plan" {
    for_each = var.plan_name != "" ? [1] : []

    content {
      name      = var.plan_name
      product   = var.plan_product
      publisher = var.plan_publisher
    }
  }

  network_interface {
    name                          = "${var.winvmss_name[count.index]}-nic-${count.index}"
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_ip_forwarding          = var.enable_ip_forwarding
    enable_accelerated_networking = var.enable_accelerated_networking
    network_security_group_id     = element(concat(azurerm_network_security_group.nsg.*.id, [""]), 0)

    ip_configuration {
      name                                   = lower("ipconig-${format("vm%s%s", lower(replace(var.winvmss_name[count.index], "/[[:^alnum:]]/", "")), count.index + 1)}")
      primary                                = true
      subnet_id                              = data.azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = var.load_balancer_exist == false && var.enable_load_balancer ? (var.backend_pool_exist ? [azurerm_lb_backend_address_pool.bepool[0].id] : null) : var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids    = var.load_balancer_exist == false && var.enable_load_balancer ? (var.enable_lb_nat_pool ? [azurerm_lb_nat_pool.natpol.0.id] : null) : var.load_balancer_inbound_nat_rules_ids

      dynamic "public_ip_address" {
        for_each = var.assign_public_ip_to_each_vm_in_vmss ? [{}] : []
        content {
          name              = lower("pip-${format("vm%s%s", lower(replace(var.winvmss_name[count.index], "/[[:^alnum:]]/", "")), count.index + 1)}")
          domain_name_label = format("vm-%s%s-pip0${count.index + 1}", lower(replace(var.winvmss_name[count.index], "/[[:^alnum:]]/", "")))
        }
      }
    }
  }
  depends_on = [azurerm_lb_rule.lbrule]

  dynamic "secret" {
    for_each = var.secret_key_vault_id != "" ? [1] : []

    content {
      key_vault_id = var.secret_key_vault_id

      dynamic "certificate" {
        for_each = var.windows_certificate_store != "" ? [1] : []

        content {
          store = var.windows_certificate_store
          url   = var.certificate_url
        }
      }
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.upgrade_mode == "Automatic" || var.upgrade_mode == "Rolling" ? [1] : []

    content {
      disable_automatic_rollback  = true
      enable_automatic_os_upgrade = true
    }
  }

  automatic_instance_repair {
    enabled      = var.enable_automatic_instance_repair
    grace_period = var.grace_period
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? [1] : []

    content {
      max_batch_instance_percent              = 20
      max_unhealthy_instance_percent          = 20
      max_unhealthy_upgraded_instance_percent = 5
      pause_time_between_batches              = "PT0S"
    }
  }

  winrm_listener {
    protocol        = var.winrm_listener_protocol
    certificate_url = var.winrm_listener_protocol == "Https" ? var.winrm_listener_certificate_url : null
  }

  terminate_notification {
    enabled = var.terminate_notification_enabled
  }
}

###
# Auto Scaling for Virtual machine scale set
###
resource "azurerm_monitor_autoscale_setting" "auto" {
  count               = var.enable_autoscale_for_vmss ? 1 : 0
  name                = lower("auto-scale-set-${var.winvmss_name[count.index]}")
  resource_group_name = data.azurerm_resource_group.vmss.name
  location            = coalesce(var.location, data.azurerm_resource_group.vmss.location)
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.0.id

  profile {
    name = "default"
    capacity {
      default = var.instances_count
      minimum = var.minimum_instances_count == null ? var.instances_count : var.minimum_instances_count
      maximum = var.maximum_instances_count
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.0.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_percentage_threshold
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = var.scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.0.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_percentage_threshold
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = var.scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }
  }
}

###
# Azure Log Analytics Workspace Agent Installation for windows
###
resource "azurerm_virtual_machine_scale_set_extension" "omsagentwin" {
  count                        = var.log_analytics_workspace_name != null ? 1 : 0
  name                         = "OmsAgentForWindows"
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "MicrosoftMonitoringAgent"
  type_handler_version         = "1.0"
  auto_upgrade_minor_version   = var.auto_upgrade_minor_version
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.*.id

  settings = <<SETTINGS
    {
      "workspaceId": "${data.azurerm_log_analytics_workspace.logws.0.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
    "workspaceKey": "${data.azurerm_log_analytics_workspace.logws.0.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

###
# azurerm monitoring diagnostics
###

resource "azurerm_monitor_diagnostic_setting" "vmmsdiag" {
  count                      = var.log_analytics_workspace_name != null && var.diag_storage_account_name != null ? 1 : 0
  name                       = lower("${var.winvmss_name[count.index]}-diag")
  target_resource_id         = azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.*.id
  storage_account_id         = data.azurerm_storage_account.storeacc.0.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logws.0.id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
