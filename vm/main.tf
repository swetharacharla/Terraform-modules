resource "azurerm_resource_group" "prod-rg" {
  name     = var.rg-01
  location = "australiaeast"
}

resource "azurerm_user_assigned_identity" "user_assiged" {
  for_each = { for k,value in var.vm_config : value.vm_name => value if lookup(value, "identity_type" ,"SystemAssigned") == "UserAssigned"}

   name                = each.value.user_assigned_name
   resource_group_name = azurerm_resource_group.prod-rg.name
   location = azurerm_resource_group.prod-rg.location
  
}
resource "azurerm_network_security_group" "prod-nsg" {
  name                = var.nsg-01
  location            = azurerm_resource_group.prod-rg.location
  resource_group_name = azurerm_resource_group.prod-rg.name
}
resource "azurerm_network_interface" "prod-nic" {
  name                = var.nic-01
  resource_group_name = azurerm_resource_group.prod-rg.name
  location            = azurerm_resource_group.prod-rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prod-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_subnet" "prod-subnet" {
  name                 = var.subnet-01
  resource_group_name  = azurerm_resource_group.prod-rg.name
  virtual_network_name = azurerm_virtual_network.prod-vn.name
  address_prefixes     = var.address_prefixes
}
resource "azurerm_virtual_network" "prod-vn" {
  name                = var.vnet-01
  location            = azurerm_resource_group.prod-rg.location
  resource_group_name = azurerm_resource_group.prod-rg.name
  address_space       = var.address-space
}

resource "azurerm_linux_virtual_machine" "prod-linux-vm" {
  for_each = { for k,value in var.vm_config : value.vm_name => value }
  name                =  each.value.vm_name
  resource_group_name = azurerm_resource_group.prod-rg.name
  location            = azurerm_resource_group.prod-rg.location

  size                = lookup(each.value,"vm_size","Standard_B1s")

  admin_username                  = "azure-prod-user"
  admin_password                  = "Cloud@123"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.prod-nic.id
  ]

  os_disk {
    caching              = lookup(each.value, "storage_account_type", "StandardSSD_LRS") == "Premium_LRS" ? "None" : "ReadWrite"
    storage_account_type = lookup(each.value, "storage_account_type", "StandardSSD_LRS")
    disk_size_gb         = 100
  }

  identity {
    type = lookup(each.value , "identity_type" , "SystemAssigned")
    identity_ids = lookup(each.value , "identity_type" , "SystemAssigned") == "UserAssigned" ? [azurerm_user_assigned_identity.user_assiged[each.value.vm_name].id] : null
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  zone = "1"
}

