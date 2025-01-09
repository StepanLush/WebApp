resource "azurerm_key_vault" "main" {
  name                = "WebApp-KeyVault-421"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "Set", "List", "Delete", "Recover", "Purge"]
  }

  access_policy {
    tenant_id = "7ade4b7e-691b-41f5-967c-020d6631338f"
    object_id = "83267db9-739b-4714-9ad0-b1ed46ad0470"

    secret_permissions = ["Get", "List"]
  }

  depends_on = [azurerm_lb.lb]
}

resource "azurerm_key_vault_secret" "vms_ips" {
  name = "ansible-inventory"
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
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "targets_vms_ips" {
  name = "targets-vms-ips"
  value = join("\n", [
    "frontend_ip: ${module.frontend_vm.public_ip}",
    "backend_ip1: ${module.backend_vms[0].public_ip}",
    "backend_ip2: ${module.backend_vms[1].public_ip}"
  ])
  key_vault_id = azurerm_key_vault.main.id
}
//дописал порт 3000 чтобы не переписывать логику fetch secrets Ansible
resource "azurerm_key_vault_secret" "load_balancer_ip" {
  name         = "load-balancer-ip"
  value        = "${azurerm_public_ip.lb_public_ip.ip_address}:3000"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "api_key" {
  name         = "api-key"
  value        = var.api_key
  key_vault_id = azurerm_key_vault.main.id
}

data "azurerm_client_config" "current" {}
