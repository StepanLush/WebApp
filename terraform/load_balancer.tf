resource "azurerm_lb" "backend" {
  name                = "backend-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend-lb-ip"
    public_ip_address_id = azurerm_public_ip.frontend_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.backend.id
}

resource "azurerm_lb_probe" "http" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.backend.id
  protocol        = "Tcp"
  port            = 3000
}

resource "azurerm_lb_rule" "http_backend" {
  name                           = "http-rule-backend"
  loadbalancer_id                = azurerm_lb.backend.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 3000
  frontend_ip_configuration_name = "frontend-lb-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_public_ip" "frontend_public_ip" {
  name                    = "frontend-public-ip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 4
}

