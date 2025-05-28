prefix = "ara-swiss"

azure-location = "westus"
# azure-location = "westeurope"
# azure-location = "switzerlandnorth"

tag_source = "terraform-f5xc-smsv2-azure apupi"
tag_owner = "ara@f5.com"

docker-instance-type = "Standard_F2"
docker-storage-account-type = "Standard_LRS"
docker-node-user = "adminuser"
docker-pub-key = "~/.ssh/id_rsa.pub"

# image details docker node
src_img_ref_docker = {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"  
}

f5xc-sms-instance-type = "Standard_DS3_v2"
# f5xc-sms-instance-type = "Standard_DS4_v2"
# f5xc-sms-instance-type = "Standard_DS5_v2"
f5xc-sms-storage-account-type = "Standard_LRS"

ce-node-user = "volterra-admin"

# image details ce node
stor_img_ref_ce = {
    publisher = "f5-networks"
    offer     = "f5xc_customer_edge"
    sku       = "f5xccebyol"
    version   = "2024.44.1"
}

xc_tenant = "f5-emea-ent-bceuutam"
xc_namespace = "a-arquint"
xc_origin_ip1 = "10.0.2.5"
xc_pub_app_port = "8080"
xc_pub_app_no_tls = "true"
xc_app_domain = "xcemea.f5demo.ch"
