resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.global_settings.location
  resource_group_name = var.global_settings.resource_group_name

  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                     = var.module_settings.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_windows_virtual_machine" "example" {
  name                  = var.module_settings.vm_worker_name
  computer_name         = var.module_settings.vm_worker_name
  resource_group_name   = var.global_settings.resource_group_name
  location              = var.global_settings.location
  size                  = "Standard_DS1_v2"
  admin_username        = var.module_settings.vm_admin_username
  admin_password        = var.module_settings.vm_admin_password
  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Specify the storage account type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  // add system assigned managed identity
  identity {
    type = "SystemAssigned"
  }

}


