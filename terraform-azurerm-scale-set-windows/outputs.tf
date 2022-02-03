output "windows_vm_password" {
  description = "Password for the windows VM"
  sensitive   = true
  value       = element(concat(random_password.passwd.*.result, [""]), 0)
}

output "load_balancer_public_ip" {
  description = "The Public IP address allocated for load balancer"
  sensitive   = true
  value       = var.load_balancer_type == "public" ? element(concat(azurerm_public_ip.pip.*.ip_address, [""]), 0) : null
}

output "load_balancer_private_ip" {
  description = "The Private IP address allocated for load balancer"
  value       = var.load_balancer_type == "private" ? element(concat(azurerm_lb.vmsslb.*.private_ip_address, [""]), 0) : null
}

output "load_balancer_nat_pool_id" {
  description = "The resource ID of the Load Balancer NAT pool."
  value       = var.enable_lb_nat_pool ? element(concat(azurerm_lb_nat_pool.natpol.*.id, [""]), 0) : null
}

output "load_balancer_health_probe_id" {
  description = "The resource ID of the Load Balancer health Probe."
  value       = var.enable_load_balancer ? element(concat(azurerm_lb_probe.lbp.*.id, [""]), 0) : null
}

output "load_balancer_rules_id" {
  description = "The resource ID of the Load Balancer Rule"
  value       = var.enable_load_balancer ? element(concat(azurerm_lb_rule.lbrule.*.id, [""]), 0) : null
}

output "network_security_group_id" {
  description = "The resource id of Network security group"
  value       = concat(azurerm_network_security_group.nsg.*.id, [""])
}

output "windows_virtual_machine_scale_set_name" {
  description = "The name of the windows Virtual Machine Scale Set."
  value       = concat(azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.*.name, [""])
}

output "windows_virtual_machine_scale_set_id" {
  description = "The resource ID of the windows Virtual Machine Scale Set."
  value       = concat(azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.*.id, [""])
}

output "windows_virtual_machine_scale_set_unique_id" {
  description = "The unique ID of the windows Virtual Machine Scale Set."
  value       = concat(azurerm_windows_virtual_machine_scale_set.az_vm_scale_set.*.unique_id, [""])
}
