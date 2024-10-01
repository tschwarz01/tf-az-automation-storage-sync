variable "global_settings" {
  description = "Global settings for the module"
  type = object({
    resource_group_name = string
    location            = string
  })

}

variable "location" {
  description = "The location in which the resources will be created"
  type        = string

}

variable "name" {
  description = "The name of the private endpoint"
  type        = string

}

variable "subnet_id" {
  description = "The ID of the subnet in which the private endpoint will be created"
  type        = string

}

variable "private_service_connection" {
  description = "Private service connection object map"
  type = object({
    name                           = string
    private_connection_resource_id = string
    subresource_names              = list(string)
    is_manual_connection           = bool

  })
}

variable "private_dns_zone_group" {
  description = "The private DNS zone group object map"
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)

  })
}

