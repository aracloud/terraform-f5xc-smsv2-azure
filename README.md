# terraform-f5xc-smsv2-azure example deployment

## Overview
In this repository, you will find Terraform plan examples for F5 Distributed Cloud deployments.

## Getting Started
The modules are available here : https://registry.terraform.io/providers/volterraedge/volterra/latest

## Pre-Requirements
Please have a F5 Distributed Cloud API Certificate ready. 
Doc for API Certificate generation: https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials 

Than "export" the env variables accordingly to authenticate via terraform:
```
export VES_P12_PASSWORD=<P12_cert_password>
export VOLT_API_URL=https://<F5_Distrubuted_Cloud_URL>/api
export VOLT_API_P12_FILE=/path/to/the/p12/file_api-creds.p12
```
