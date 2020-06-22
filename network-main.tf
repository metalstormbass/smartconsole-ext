# Create a resource group for SC_EXT
resource "azurerm_resource_group" "network-rg" {
  name     = "${var.function_name}-rg"
  location = var.location
  tags = {
    application = var.function_name
    environment = var.environment
  }
}

# Create the SC_EXT VNET
resource "azurerm_virtual_network" "network-vnet" {
  name                = "${var.function_name}-vnet"
  address_space       = [var.network-vnet-cidr]
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
  tags = {
    application = var.function_name
    environment = var.environment
  }
}

# Create a SC_EXT Subnet
resource "azurerm_subnet" "network-subnet" {
  name                 = "${var.function_name}-subnet"
  address_prefix       = var.network-subnet-cidr
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}
