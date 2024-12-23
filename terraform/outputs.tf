output "ansible_inventory" {
  value = join("\n", [
    "[frontend]",
    module.frontend_vm.public_ip,
    "",
    "[backend]",
    join("\n", module.backend_vms.*.public_ip),
    "",
    "[monitoring]",
    module.monitoring_vm.public_ip
  ])
}

output "targets_vms_ips" {
  value = join("\n", [
    "frontend_ip: ${module.frontend_vm.public_ip}",
    "backend_ip1: ${module.backend_vms[0].public_ip}",
    "backend_ip2: ${module.backend_vms[1].public_ip}"
  ])
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.frontend_public_ip.ip_address
}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}
