locals {
  vm_worker_settings = {
    subnet_id          = var.module_settings.subnet_id
    vm_worker_name     = var.module_settings.vm_worker_name
    automation_account = azurerm_automation_account.auto-acct
    vm_admin_username  = var.module_settings.vm_admin_username
    vm_admin_password  = var.module_settings.vm_admin_password
  }
}
