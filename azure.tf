####################################
# azure resource definitions


resource "azurerm_resource_group" "azure_rg" {
  name     = "${var.prefix}-ce-rg-${random_id.xc-mcn-random-id.hex}"
  location = "${var.azure-location}"
  tags = {
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = var.tag_source_host
    create = local.today-timestamp
  }
}

resource "azurerm_virtual_network" "azure_vn" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
}

resource "azurerm_subnet" "azure_sn" {
  name                 = "${var.prefix}-sn-internal"
  resource_group_name  = azurerm_resource_group.azure_rg.name
  virtual_network_name = azurerm_virtual_network.azure_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "azure_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-65500"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 65500
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-80"
    priority                   = 1101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*" 
    destination_port_range     = 80
    source_address_prefix      = "*" 
    destination_address_prefix = "*" 
  }

  security_rule {
    name                       = "Allow-ICMP"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
