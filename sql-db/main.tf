resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg-01
  location = "australiaeast"
}


resource "azurerm_mssql_server" "prod-server" {
  name                         = var.sql-server
  resource_group_name          = azurerm_resource_group.prod-rg.name
  location                     = azurerm_resource_group.prod-rg.location
  version                      = "12.0"
  administrator_login          = "swethaprod123"
  administrator_login_password = "Cloud@87654321"
}

resource "azurerm_mssql_database" "prod-mssql-database" {
  name                                = var.sql-db
  server_id                           = azurerm_mssql_server.prod-server.id
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  license_type                        = "LicenseIncluded"
  max_size_gb                         = 4
  sku_name                            = "BC_Gen5_2"
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
}