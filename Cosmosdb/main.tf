resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg-01
  location = "australiaeast"
}

resource "azurerm_cosmosdb_account" "prod-db" {
    for_each = { for k,value in var.cosmosdb_config : value.cosmosdb_name => value }
  name                = each.value.cosmosdb_name
  location            = azurerm_resource_group.prod-rg.location
  resource_group_name = azurerm_resource_group.prod-rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = each.value.consistency_level
  }

  geo_location {
    location          = "australiaeast"
    failover_priority = 0
  }
}


