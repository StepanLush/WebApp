resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[count.index].address_prefix]
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.subnets)
  name                = "${var.subnets[count.index].name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

resource "azurerm_network_security_rule" "security_rules" {
  for_each = {
    for entry in flatten([
      for s in var.subnets : [
        for r in s.security_rules : {
          key = "${s.name}-${r.name}"
          value = {
            name                    = r.name
            priority                = r.priority
            protocol                = r.protocol
            destination_port_ranges = r.destination_port_ranges
            subnet_name             = s.name
          }
        }
      ]
    ]) : entry.key => entry.value
  }



  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = each.value.protocol
  source_port_range          = "*"
  destination_port_ranges    = each.value.destination_port_ranges
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = var.resource_group_name
  network_security_group_name = lookup({
    for idx, ns in azurerm_network_security_group.nsg :
    azurerm_subnet.subnet[idx].name => ns.name
  }, each.value.subnet_name)
}



