#################################### 
# define local varaiables

locals {
  smsv2-site-name = "${var.prefix}-ce-azure-${random_id.xc-mcn-random-id.hex}"
}


####################################
# define planet wide vars :-)

variable "prefix" {
  description = "prefix for created objects"
  type = string
}

####################################
# define azure wide vars

variable "azure-location" {
  description = "azure location to run the deployment"
  type = string
}

# tag: source "git" and "host" for azure resource group 
variable "tag_source" {
  type = string
}

# tag: owner azure resource group
variable "tag_owner" {
  type = string
}

# azure docker node instance type
variable "docker-instance-type" {
  description = "instance type"
  type = string
}

# azure docker node disk type
variable "docker-storage-account-type" {
  description = "storage account type"
  type = string
}

# azure docker node user
variable "docker-node-user" {
  description = "docker user"
  type = string
}

# azure ssh public key
variable "docker-pub-key" {
  description = "public key on terraform machine"
  type = string
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
}

# azure ce node type
variable "f5xc-sms-instance-type" {
  description = "instance type"
  type = string
}

# azure ce node disk type
variable "f5xc-sms-storage-account-type" {
  description = "storage account type"
  type = string
}

# ce node user
variable "ce-node-user" {
  description = "ce user"
  type = string
}

# azure ce node image reference
variable "stor_img_ref_ce" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

####################################
# XC lb related vars

# tenant
variable "xc_tenant" {
  type = string
}

# site reference
#variable "xc_tenant_site" {
#  type = string
#  default = ${local.smsv2-site-name}
#}

# namespace
variable "xc_namespace" {
  type = string
}

# pool name
#variable "xc_origin_pool" {
#  type = string
#  default = ${local.smsv2-site-name}
#}

# pool member backend ip address
variable "xc_origin_ip1" {
  type = string
}

# origin pool service port
variable "xc_pub_app_port" {
  type = string
}

# origin pool no tls
variable "xc_pub_app_no_tls" {
  type = string
}

# application domain
variable "xc_app_domain" {
  type = string
}

