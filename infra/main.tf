terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}
 
provider "azurerm" {
  features {}
  subscription_id =  "65ff69bf-9516-46ed-b7bf-e4e4756db000"
}
 
 
resource "azurerm_resource_group" "rg1" {
  name     = "azure-functions-rg"
  location = "West Europe"
}
 
resource "azurerm_storage_account" "sa" {
  name                     = "co2emissionssa"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
 
resource "azurerm_app_service_plan" "asp" {
  name                = "azure-functions-asp-sp"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  kind                = "Linux"
  reserved            = true
 
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
 
  lifecycle {
    ignore_changes = [
      kind
    ]
  }
}
 
resource "azurerm_function_app" "example" {
  name                       = "co2emissions"
  location                   = azurerm_resource_group.rg1.location
  resource_group_name        = azurerm_resource_group.rg1.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  os_type                    = "linux"
  version                    = "~4"
 
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
 
  site_config {
    linux_fx_version = "python|3.11"
  }
}