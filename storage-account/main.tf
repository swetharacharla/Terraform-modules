resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg_01
  location = "australiaeast"
}


resource "azurerm_storage_account" "prod-storage" {
for_each = { for k , value in var.storage_config : value.storage_account_name => value }
  name                     = each.value.storage_account_name
  resource_group_name      = azurerm_resource_group.prod-rg.name
  location                 = azurerm_resource_group.prod-rg.location
  account_kind             = lookup( each.value,"account_kind", "Storage" )
  account_tier             = lookup( each.value, "account_tier", "Standard" )
  account_replication_type = "LRS"
  access_tier              = "Hot"

}