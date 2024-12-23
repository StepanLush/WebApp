output "vm_id" {
  value = azurerm_virtual_machine.vm.id
}

output "public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}

output "network_interface_id" {
  value = azurerm_network_interface.vm_nic.id
}
