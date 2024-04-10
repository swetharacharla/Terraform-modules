resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg_01
  location = "australiaeast"
}


resource "azurerm_storage_account" "prod-storage" {
  count = 2
  name                     = "${var.strg_01}${count.index}"
  resource_group_name      = azurerm_resource_group.prod-rg.name
  location                 = azurerm_resource_group.prod-rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

}