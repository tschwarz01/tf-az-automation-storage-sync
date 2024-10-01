output "destination-storage-account" {
  value = azurerm_storage_account.stgdst
}

output "subnet" {
  value = azurerm_subnet.auto-acct-subnet
}
