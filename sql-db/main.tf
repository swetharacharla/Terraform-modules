
locals {
  db_config = flatten([ for server in var.sqlserrver_config :
  [ for db in server.ssdb_config :
  {
    server_name = server.ss_name
    db_name = db.ssdb_name
    sku_name = lookup(db, "sku_name", "BC_GEN5_2")
    
  }]])

  
  
}

output "db" {
  value = local.db_config
  
}
resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg-01
  location = "australiaeast"
}


resource "azurerm_mssql_server" "prod-server" {
  for_each = {for k , value in var.sqlserrver_config: value.ss_name => value }
  name = each.value.ss_name
  resource_group_name          = azurerm_resource_group.prod-rg.name
  location                     = azurerm_resource_group.prod-rg.location
  version                      = "12.0"
  administrator_login          = "swethaprod123"
  administrator_login_password = "Cloud@87654321"
}

resource "azurerm_mssql_database" "prod-mssql-database" {
  for_each = {for k, value in local.db_config : value.db_name => value}
  name                                = each.value.db_name
  server_id                           = azurerm_mssql_server.prod-server[each.value.server_name].id
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  license_type                        = "LicenseIncluded"
  max_size_gb                         = 4
  sku_name                            = "BC_Gen5_2"
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true

}


