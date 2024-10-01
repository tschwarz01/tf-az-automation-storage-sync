variable "global_settings" {
  description = "Global settings for the module"
  type = object({
    resource_group_name = string
    location            = string
  })

}

variable "module_settings" {
  description = "Settings for the module"
  type = object({
    vm_worker_name    = string
    vm_admin_username = string
    vm_admin_password = string
    auto_acct_name    = string
    subnet_id         = string
    destination_storage_account = object({
      name = string
      id   = string
    })
    source_storage_account_id = string
  })

}
