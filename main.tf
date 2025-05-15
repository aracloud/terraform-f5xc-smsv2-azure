resource "random_id" "xc-mcn-random-id" {
  byte_length = 2
}

resource "random_string" "password" {
  length      = 10
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}



####################################
# xc resource definitions

# xc smsv2 site
resource "volterra_securemesh_site_v2" "xc-mcn-smsv2-appstack" {
  name      = local.smsv2-site-name
  namespace = "system"

  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = false

  labels = {
    "ves.io/provider"     = "ves-io-azure"
    "de1chk1nd-mcn-sites" = "vk8s"
  }

  re_select {
    geo_proximity = true
  }

  azure {
    not_managed {}
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
  }
}

# xc ce initialization token 
resource "volterra_token" "xc-mcn-sitetoken" {
  name      = "${var.prefix}-token-${random_id.xc-mcn-random-id.hex}"
  namespace = "system"
  type = "1"
  site_name = local.smsv2-site-name
  depends_on = [volterra_securemesh_site_v2.xc-mcn-smsv2-appstack]
}



####################################
# azure resource definitions

resource "azurerm_virtual_machine" "f5xc-nodes" {
  depends_on                   = [azurerm_network_interface_security_group_association.azure_nisga_ce]
  name                         = local.smsv2-site-name
  location                     = azurerm_resource_group.azure_rg.location
  resource_group_name          = azurerm_resource_group.azure_rg.name
  primary_network_interface_id = azurerm_network_interface.azure_nic_ce.id
  network_interface_ids        = [azurerm_network_interface.azure_nic_ce.id]
  vm_size                      = var.f5xc-sms-instance-type

  # Uncomment these lines to delete the disks automatically when deleting the VM
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  identity {
    type = "SystemAssigned"
  }

  plan {
    name      = "f5xccebyol"
    publisher = "f5-networks"
    product   = "f5xc_customer_edge"
  }

  storage_image_reference {
    publisher = var.stor_img_ref_ce.publisher
    offer     = var.stor_img_ref_ce.offer
    sku       = var.stor_img_ref_ce.sku
    version   = var.stor_img_ref_ce.version
  }

  storage_os_disk {
    name              = "${var.prefix}-ce-node-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.f5xc-sms-storage-account-type
  }

  os_profile {
    computer_name  = "${var.prefix}-node-${random_id.xc-mcn-random-id.hex}"
    admin_username = var.ce-node-user
    admin_password = random_string.password.result
    custom_data = base64encode(templatefile("${path.module}/user-data.tpl", {
      cluster_name = local.smsv2-site-name,
      token = volterra_token.xc-mcn-sitetoken.id
    }))
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name   = "{var.prefix}-node-[random_id.xc-mcn-random-id.hex]"
    source = "terraform"
    owner  = var.tag_owner
  }
}

resource "azurerm_resource_group" "azure_rg" {
  name     = "${var.prefix}-rg-${random_id.xc-mcn-random-id.hex}"
  location = "${var.azure-location}"
  tags = {
    source = var.tag_source
    owner  = var.tag_owner
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

resource "azurerm_public_ip" "azure_pip_ce" {
  name                = "${var.prefix}-pip-ce"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "azure_pip_dkr" {
  name                = "${var.prefix}-pip-dkr"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "azure_nic_ce" {
  name                = "${var.prefix}-nic-ce"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.azure_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_pip_ce.id
  }
}

resource "azurerm_network_interface" "azure_nic_dkr" {
  name                = "${var.prefix}-nic-dkr"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.azure_sn.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.xc_origin_ip1
    public_ip_address_id          = azurerm_public_ip.azure_pip_dkr.id
  }
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

resource "azurerm_network_interface_security_group_association" "azure_nisga_ce" {
  network_interface_id    = azurerm_network_interface.azure_nic_ce.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

resource "azurerm_network_interface_security_group_association" "azure_nisga_dkr" {
  network_interface_id    = azurerm_network_interface.azure_nic_dkr.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

# azure docker host running workloads
resource "azurerm_linux_virtual_machine" "azure_dkr" {
  depends_on          = [azurerm_network_interface_security_group_association.azure_nisga_dkr]
  name                = "${var.prefix}-dkr-node"
  resource_group_name = azurerm_resource_group.azure_rg.name
  location            = azurerm_resource_group.azure_rg.location
  size                = var.docker-instance-type
  admin_username      = var.docker-node-user

  network_interface_ids = [
    azurerm_network_interface.azure_nic_dkr.id,
  ]

  admin_ssh_key {
    username   = var.docker-node-user
    public_key = file("${var.docker-pub-key}")
  }

  os_disk {
    name                 = "${var.prefix}-dkr-node-disk"
    caching              = "ReadWrite"
    storage_account_type = var.docker-storage-account-type
  }

  source_image_reference {
    publisher = var.src_img_ref_docker.publisher
    offer     = var.src_img_ref_docker.offer
    sku       = var.src_img_ref_docker.sku
    version   = var.src_img_ref_docker.version
  }

  custom_data = filebase64("${path.module}/custom-data.tpl")
}
