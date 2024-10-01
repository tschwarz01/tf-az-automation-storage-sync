
resource "azurerm_resource_group" "rg-automation" {
  name     = var.global_settings.resource_group_name
  location = var.global_settings.location
}

resource "azurerm_virtual_network" "auto-acct-vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.global_settings.location
  resource_group_name = azurerm_resource_group.rg-automation.name
}

resource "azurerm_subnet" "auto-acct-subnet" {
  name                 = "auto-acct-subnet"
  resource_group_name  = azurerm_resource_group.rg-automation.name
  virtual_network_name = azurerm_virtual_network.auto-acct-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

// Create a storage account to be used as the destination for the copy operation
resource "azurerm_storage_account" "stgdst" {
  name                          = var.module_settings.dest_storage_acct_name
  resource_group_name           = azurerm_resource_group.rg-automation.name
  location                      = var.global_settings.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  is_hns_enabled                = true
  public_network_access_enabled = false
}

resource "azurerm_private_dns_zone" "private_dns_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg-automation.name
}

resource "azurerm_private_dns_zone" "private_dns_zone_dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = azurerm_resource_group.rg-automation.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-vnet-link" {
  name                  = "private-dns-blob-vnet-link"
  resource_group_name   = azurerm_resource_group.rg-automation.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_blob.name
  virtual_network_id    = azurerm_virtual_network.auto-acct-vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-vnet-link" {
  name                  = "private-dns-dfs-vnet-link"
  resource_group_name   = azurerm_resource_group.rg-automation.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_dfs.name
  virtual_network_id    = azurerm_virtual_network.auto-acct-vnet.id
}

module "priv-ep-blob" {
  source          = "../../services/priv-ep"
  global_settings = var.global_settings
  location        = var.global_settings.location
  subnet_id       = azurerm_subnet.auto-acct-subnet.id
  name            = "pe-blob-${var.module_settings.dest_storage_acct_name}"
  private_service_connection = {
    name                           = "${var.module_settings.dest_storage_acct_name}-blob"
    private_connection_resource_id = azurerm_storage_account.stgdst.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group = {
    name                 = "blob-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_blob.id]
  }
}

module "priv-ep-dfs" {
  source          = "../../services/priv-ep"
  global_settings = var.global_settings
  location        = var.global_settings.location
  subnet_id       = azurerm_subnet.auto-acct-subnet.id
  name            = "pe-dfs-${var.module_settings.dest_storage_acct_name}"
  private_service_connection = {
    name                           = "${var.module_settings.dest_storage_acct_name}-dfs"
    private_connection_resource_id = azurerm_storage_account.stgdst.id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }
  private_dns_zone_group = {
    name                 = "dfs-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_dfs.id]
  }
}

