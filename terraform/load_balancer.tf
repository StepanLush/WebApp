resource "azurerm_lb" "lb" {
  name                = "lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb-ip"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool" "frontend_pool" {
  name            = "frontend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http_3000" {
  name            = "http-probe-3000"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 3000
}

resource "azurerm_lb_probe" "http_80" {
  name            = "http-probe-80"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http_frontend" {
  name                           = "http-rule-backend"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb-ip"
  backend_address_pool_ids       = [azurerm_lb_frontend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_80.id
}

resource "azurerm_lb_rule" "http_backend" {
  name                           = "http-rule-backend"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 3000
  backend_port                   = 3000
  frontend_ip_configuration_name = "lb-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.frontend_pool.id]
  probe_id                       = azurerm_lb_probe.http_3000.id
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                    = "lb-public-ip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 4
}

