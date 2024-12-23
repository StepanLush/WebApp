output "vnet_id" {
  description = "ID виртуальной сети"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Список ID подсетей"
  value       = [for s in azurerm_subnet.subnet : s.id]
}

output "nsg_ids" {
  description = "Список ID NSG"
  value       = [for n in azurerm_network_security_group.nsg : n.id]
}
