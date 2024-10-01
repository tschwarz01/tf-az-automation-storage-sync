# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "8c881d12-a2a2-4d4a-a9d8-76d1b121d014"
  # resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

}
