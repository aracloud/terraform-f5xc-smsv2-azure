#################################### 
# define local varaiables

locals {
  smsv2-site-name = "${var.prefix}-azure-${random_id.xc-mcn-swiss-1-id.hex}"
}


####################################
# define planet wide vars :-)

variable "prefix" {
  description = "prefix for created objects"
  default = "ara-swiss"
}

variable "azure-location" {
  description = "azure location to run the deployment"
  default = "switzerlandnorth"
}

# azure docker node type
variable "docker-instance-type" {
  description = "instance type"
  default = "Standard_F2"
}

# azure docker node disk type
variable "docker-storage-account-type" {
  description = "storage account type"
  default = "Standard_LRS"
}

# azure docker node user
variable "docker-node-user" {
  description = "docker user"
  default = "adminuser"
}

# azure docker node image reference
# (corresponds with custom-data.tpl)
variable "src_img_ref_docker" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"    
  }
}

# azure ce node type
variable "f5xc-sms-instance-type" {
  description = "instance type"
  default = "Standard_DS4_v2"
}

# azure ce node disk type
variable "f5xc-sms-storage-account-type" {
  description = "storage account type"
  default = "Standard_LRS"
}

# ce node user
variable "ce-node-user" {
  description = "ce user"
  default = "volterra-admin"
}

# ce tag owner
variable "tag_owner" {
  description = ""
  default = "user@example.moc"
}

# azure ce node image reference
variable "stor_img_ref_ce" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "f5-networks"
    offer     = "f5xc_customer_edge"
    sku       = "f5xccebyol"
    version   = "2024.44.1"
  }
}
