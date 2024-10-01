# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "053b13a3-b373-4eab-84f6-00f4d045f19d"
  # resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

}
