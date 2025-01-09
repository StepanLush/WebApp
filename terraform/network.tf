module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = "my-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  subnets = [
    {
      name           = "frontend-subnet"
      address_prefix = "10.0.1.0/24"
      security_rules = [
        {
          name                    = "allow-ssh"
          protocol                = "Tcp"
          destination_port_ranges = ["22"]
          priority                = 1000
        },
        {
          name                    = "allow-http"
          protocol                = "Tcp"
          destination_port_ranges = ["80"]
          priority                = 2000
        },
        {
          name                    = "allow-backend-3000"
          protocol                = "Tcp"
          source_address_prefix   = "10.0.2.0/24" # backend-subnet
          destination_port_ranges = ["3000"]
          priority                = 3000
        },
        {
          name                    = "allow-prometheus"
          protocol                = "Tcp"
          destination_port_ranges = ["9113"]
          priority                = 4000
        }
      ]
    },
    {
      name           = "backend-subnet"
      address_prefix = "10.0.2.0/24"
      security_rules = [
        {
          name                    = "allow-ssh"
          protocol                = "Tcp"
          destination_port_ranges = ["22"]
          priority                = 1000
        },
        {
          name                    = "allow-http"
          protocol                = "Tcp"
          destination_port_ranges = ["3000"]
          priority                = 2000
        },
        {
          name                    = "allow-lb"
          protocol                = "Tcp"
          source_address_prefix   = "AzureLoadBalancer"
          destination_port_ranges = ["3000"]
          priority                = 100
        }
      ]
    },
    {
      name           = "monitoring-subnet"
      address_prefix = "10.0.3.0/24"
      security_rules = [
        {
          name                    = "allow-ssh"
          protocol                = "Tcp"
          destination_port_ranges = ["22"]
          priority                = 1000
        },
        {
          name                    = "allow-prometheus"
          protocol                = "Tcp"
          destination_port_ranges = ["9090"]
          priority                = 2000
        }
      ]
    }
    # {
    #   name           = "db-subnet"
    #   address_prefix = "10.0.4.0/24"
    #   security_rules = [
    #     {
    #       name                    = "allow-ssh"
    #       protocol                = "Tcp"
    #       destination_port_ranges = ["22"]
    #       priority                = 1000
    #     }
    #   ]
    # }
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_nic_association" {
  count                   = length(local.backend_nic_ids)
  network_interface_id    = local.backend_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "frontend_nic_association" {
  count                   = length(local.frontend_nic_ids)
  network_interface_id    = local.frontend_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend_pool.id
  depends_on = [
    azurerm_network_interface.frontend_vm_nic,
    azurerm_lb_backend_address_pool.frontend_pool
  ]
}

