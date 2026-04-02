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

  custom_data = filebase64("${path.module}/docker-data.tpl")
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

resource "azurerm_network_interface_security_group_association" "azure_nisga_dkr" {
  network_interface_id    = azurerm_network_interface.azure_nic_dkr.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

resource "azurerm_public_ip" "azure_pip_dkr" {
  name                = "${var.prefix}-pip-dkr"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
  allocation_method   = "Dynamic"
}