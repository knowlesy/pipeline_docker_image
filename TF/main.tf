#brings in some data from your Az login session
data "azurerm_client_config" "current" {}
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}
#creates RG
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_string" "azurerm_sa_name" {
  length  = 10
  lower   = true
  numeric = true
  special = false
  upper   = false
}


resource "azurerm_container_registry" "acr" {
  name                = coalesce("cr${random_string.azurerm_sa_name.result}")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false

}