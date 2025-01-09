module "backend_vms" {
  source              = "./modules/vm"
  count               = 2
  vm_name             = "backend-vm-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.vnet.subnet_ids[1] # backend-subnet
  vm_size             = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  ssh_public_key      = var.ssh_public_key //file("~/.ssh/id_rsa.pub")
}

module "frontend_vm" {
  source              = "./modules/vm"
  vm_name             = "frontend-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.vnet.subnet_ids[0] # frontend-subnet
  vm_size             = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  ssh_public_key      = var.ssh_public_key //file("~/.ssh/id_rsa.pub")
}

module "monitoring_vm" {
  source              = "./modules/vm"
  vm_name             = "monitoring-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.vnet.subnet_ids[2] # monitoring-subnet
  vm_size             = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  ssh_public_key      = var.ssh_public_key //file("~/.ssh/id_rsa.pub")
}

locals {
  backend_nic_ids = [
    for i in range(length(module.backend_vms)) : module.backend_vms[i].network_interface_id
  ]

  frontend_nic_ids = [
    module.frontend_vm.network_interface_id
  ]
}
