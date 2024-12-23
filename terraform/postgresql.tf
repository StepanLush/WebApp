# resource "azurerm_postgresql_server" "main" {
#   name                         = "postgresql-server-632"
#   location                     = azurerm_resource_group.main.location
#   resource_group_name          = azurerm_resource_group.main.name
#   sku_name                     = "B_Gen5_1"
#   storage_mb                   = 5120
#   backup_retention_days        = 7
#   geo_redundant_backup_enabled = false
#   administrator_login          = var.db_admin_username
#   administrator_login_password = var.db_admin_password
#   version                      = "11"
#   ssl_enforcement_enabled      = true
# }

# resource "azurerm_postgresql_database" "main" {
#   name                = "mydatabase"
#   resource_group_name = azurerm_resource_group.main.name
#   server_name         = azurerm_postgresql_server.main.name
#   charset             = "UTF8"
#   collation           = "en_US.UTF8"
# }
