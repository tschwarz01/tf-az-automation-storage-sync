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
    subnet_id         = string
    vm_admin_username = string
    vm_admin_password = string
    automation_account = object({
      name               = string
      hybrid_service_url = string
    })
  })

}
