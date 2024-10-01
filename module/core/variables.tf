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
    source_stg_acct_name   = string
    source_stg_acct_id     = string
    dest_storage_acct_name = string
  })

}
