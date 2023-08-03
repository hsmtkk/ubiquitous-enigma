resource "azurerm_virtual_network" "main" {
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  name                = "main"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "bastion" {
  address_prefixes     = ["192.168.0.0/24"]
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "data" {
  address_prefixes     = ["192.168.1.0/24"]
  name                 = "data"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "business" {
  address_prefixes     = ["192.168.2.0/24"]
  name                 = "business"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "gateway" {
  address_prefixes     = ["192.168.3.0/24"]
  name                 = "gateway"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_network_security_group" "gateway" {
  location            = azurerm_virtual_network.main.location
  name                = "gateway"
  resource_group_name = azurerm_virtual_network.main.resource_group_name
  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_ranges    = [80, 443]
    direction                  = "Inbound"
    name                       = "gateway"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "gateway" {
  network_security_group_id = azurerm_network_security_group.gateway.id
  subnet_id                 = azurerm_subnet.gateway.id
}

resource "azurerm_network_security_group" "business" {
  location            = azurerm_virtual_network.main.location
  name                = "business"
  resource_group_name = azurerm_virtual_network.main.resource_group_name
  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_ranges    = [22, 3000]
    direction                  = "Inbound"
    name                       = "business"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "business" {
  network_security_group_id = azurerm_network_security_group.business.id
  subnet_id                 = azurerm_subnet.business.id
}

resource "azurerm_network_security_group" "data" {
  location            = azurerm_virtual_network.main.location
  name                = "data"
  resource_group_name = azurerm_virtual_network.main.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "data" {
  network_security_group_id = azurerm_network_security_group.data.id
  subnet_id                 = azurerm_subnet.data.id
}

resource "azurerm_network_security_group" "bastion" {
  location            = azurerm_virtual_network.main.location
  name                = "bastion"
  resource_group_name = azurerm_virtual_network.main.resource_group_name
}

#resource "azurerm_subnet_network_security_group_association" "bastion" {
#  network_security_group_id = azurerm_network_security_group.bastion.id
#  subnet_id                 = azurerm_subnet.bastion.id
#}
