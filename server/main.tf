resource "azurerm_resource_group" "dev-rg" {
  name     = var.rg-first
  location = "australiaeast"
}


resource "azurerm_mssql_server" "devserver" {
  for_each = { for k, value in var.server_config : value.server_name => value }

  name                         = each.value.server_name
  resource_group_name          = azurerm_resource_group.dev-rg.name
  location                     = azurerm_resource_group.dev-rg.location
  version                      = "12.0"
  administrator_login          = "swethaprod123"
  administrator_login_password = "Cloud@87654321"
}

resource "azurerm_mssql_database" "dev-server-database" {
  name                                = var.db-01
  server_id                           = azurerm_mssql_server.devserver["swetha-dev-01"].id
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  license_type                        = "LicenseIncluded"
  max_size_gb                         = 4
  sku_name                            = "BC_Gen5_2"
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
}
