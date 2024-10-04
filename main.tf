terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stgtfstateeslz"
    container_name       = "tfstateautomation"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

data "azuread_client_config" "current" {}
data "azurerm_client_config" "default" {}
data "azurerm_subscription" "current" {}
data "azurerm_storage_account" "stgsrc" {
  provider            = azurerm.DLZ
  name                = var.source_stg_acct_name
  resource_group_name = var.source_stg_account_resource_group
}


module "core" {
  source          = "./module/core"
  global_settings = local.global_settings
  module_settings = local.core_module_settings

}


module "automation" {
  source          = "./module/automation"
  global_settings = local.global_settings
  module_settings = local.automation_module_settings
}

