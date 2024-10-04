# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "053b13a3-b373-4eab-84f6-00f4d045f19d" # TWS
  # resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

}

provider "azurerm" {
  alias           = "DLZ"
  subscription_id = "f4b71bff-7f98-47a7-ba03-f48b5c093a7f" # TWS
  features {}
}
