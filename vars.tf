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

####################################
# define azure wide vars

variable "azure-location" {
  description = "azure location to run the deployment"
  #default = "westus"
  default = "westeurope"
  #default = "switzerlandnorth"
}

# tag: source "git" and "host" for azure resource group 
variable "tag_source" {
  default = "terraform-f5xc-smsv2-azure debian03"
}

# tag: owner azure resource group
variable "tag_owner" {
  default = "ara@f5.com"
}

# azure docker node instance type
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

# azure ssh public key
variable "docker-pub-key" {
  description = "public key on terraform machine"
  default = "~/.ssh/id_rsa.pub"
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

####################################
# XC lb related vars

# tenant
variable "xc_tenant" {
  type = string
  default = "f5-emea-ent-bceuutam"
}

# site reference
#variable "xc_tenant_site" {
#  type = string
#  default = ${local.smsv2-site-name}
#}

# namespace
variable "xc_namespace" {
  type = string
  default = "a-arquint"
}

# pool name
#variable "xc_origin_pool" {
#  type = string
#  default = ${local.smsv2-site-name}
#}

# pool member backend ip address
variable "xc_origin_ip1" {
  type = string
  default = "10.0.2.5"
}

# origin pool service port
variable "xc_pub_app_port" {
  type = string
  default = "8080"
}

# origin pool no tls
variable "xc_pub_app_no_tls" {
  type = string
  default = "true"
}

# application domain
variable "xc_app_domain" {
  type = string
  default = "xcemea.f5demo.ch"
}

