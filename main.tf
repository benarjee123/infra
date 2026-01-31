resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-sample"
  address_space       = ["10.0.0.0/16"]
  location            = "West US 2"
  resource_group_name = "Testing"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-sample"
  resource_group_name  = "Testing"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_storage_account" "sa" {
  name                     = "stdevopssample123"
  resource_group_name      = "Testing"
  location                 = "West US 2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-sample"
  location            = "West US 2"
  resource_group_name = "Testing"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-sample"
  resource_group_name   = "Testing"
  location              = "West US 2"
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
