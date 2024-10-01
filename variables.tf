
variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  type        = string

}

variable "location" {
  description = "The location in which the resources will be created"
  type        = string
}

variable "source_stg_acct_name" {
  description = "The name of the source storage account"
  type        = string
}

variable "source_stg_account_resource_group" {
  description = "The name of the resource group in which the source storage account is located"
  type        = string

}

variable "dest_storage_acct_name" {
  description = "The name of the destination storage account"
  type        = string
}

variable "vm_worker_name" {
  description = "The name of the VM worker"
  type        = string

}

variable "auto_acct_name" {
  description = "The name of the automation account"
  type        = string
  default     = "ex-auto-acct-0032"
}

variable "priv_dns_zone_id_blob" {
  description = "The ID of the private DNS zone for blob storage"
  type        = string
  default     = "/subscriptions/8c881d12-a2a2-4d4a-a9d8-76d1b121d014/resourceGroups/centralus-fdx-canada-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
}

variable "priv_dns_zone_id_dfs" {
  description = "The ID of the private DNS zone for Data Lake Storage Gen2"
  type        = string
  default     = "/subscriptions/8c881d12-a2a2-4d4a-a9d8-76d1b121d014/resourceGroups/centralus-fdx-canada-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
}

variable "vm_admin_username" {
  description = "The username for the VM"
  type        = string
  default     = "adminuser"
}

variable "vm_admin_password" {
  description = "The password for the VM"
  type        = string

}
