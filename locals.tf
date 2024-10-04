locals {

  global_settings = {
    location            = var.location
    resource_group_name = var.resource_group_name

    client_config = {
      client_id       = data.azurerm_client_config.default.client_id
      tenant_id       = data.azurerm_client_config.default.tenant_id
      subscription_id = data.azurerm_subscription.current.id
      #object_id               = data.azurerm_client_config.default.object_id == null || data.azurerm_client_config.default.object_id == "" ? data.azuread_client_config.current.object_id : null
      object_id               = data.azurerm_client_config.default.object_id
      logged_user_objectId    = data.azurerm_client_config.default.object_id
      logged_aad_app_objectId = data.azurerm_client_config.default.object_id
    }
  }

  core_module_settings = {
    source_stg_acct_name   = data.azurerm_storage_account.stgsrc.name
    source_stg_acct_id     = data.azurerm_storage_account.stgsrc.id
    dest_storage_acct_name = var.dest_storage_acct_name
  }

  automation_module_settings = {
    vm_worker_name              = var.vm_worker_name
    auto_acct_name              = var.auto_acct_name
    subnet_id                   = module.core.subnet.id
    destination_storage_account = module.core.destination-storage-account
    source_storage_account_id   = data.azurerm_storage_account.stgsrc.id
    source_storage_account_name = data.azurerm_storage_account.stgsrc.name
    vm_admin_username           = var.vm_admin_username
    vm_admin_password           = var.vm_admin_password
  }

}
