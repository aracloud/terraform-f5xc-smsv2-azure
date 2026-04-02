

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
    "ves.io/provider"     = "ves-io-AZURE"
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
    custom_data = base64encode(templatefile("${path.module}/ce-data.tpl", {
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

resource "azurerm_network_interface_security_group_association" "azure_nisga_ce" {
  network_interface_id    = azurerm_network_interface.azure_nic_ce.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

resource "azurerm_public_ip" "azure_pip_ce" {
  name                = "${var.prefix}-pip-ce"
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
  allocation_method   = "Dynamic"
}