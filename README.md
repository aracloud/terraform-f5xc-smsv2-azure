# Customer Edge (CE) with Public IP Assignment (Usable for All Normal Use Cases)

## Overview
This Terraform project deploys a single Azure virtual machine (VMs) integrated with F5 SaaS
using single NIC configuration and a docker host in **Azure** with a demo application
for demo or PoC purposes only.

The deployment will create a random id which is used for several object
naming conventions.

---

## Getting Started
The modules are available here : https://registry.terraform.io/providers/volterraedge/volterra/latest

## Prerequisites

Before using this Terraform project, ensure you have the following:

- **Terraform CLI** installed on your machine
- An **Azure account** (CLI "az login") to create **subnets**, **security groups** etc.
- API Certificate (P12 file and URL) for **F5 SaaS** access
- SSH public key for VM authentication (optional)

Doc for API Certificate generation: https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials 

---

```
project-directory/
├── app.tf
├── custom-data.tpl
├── LICENSE
├── main.tf
├── providers.tf
├── README.md
├── user-data.tpl
└── vars.tf
```

---

## Configuration Steps

### 1. Clone the Repository

```bash
git clone <repository_url>
cd <repository_name>
```

### 2. export F5 SaaS variables

Than "export" the env variables accordingly to authenticate via terraform:

```
export VES_P12_PASSWORD=<P12_cert_password>
export VOLT_API_URL=https://<F5_Distrubuted_Cloud_URL>/api
export VOLT_API_P12_FILE=/path/to/the/p12/file_api-creds.p12
```


### 3. Update Variables

#### Modify `vars.tf`
Update the values in `vars.tf` to match your deployment needs.

Here are some key variables to configure:

- **Planet wide Variables:**
  ```hcl
  prefix = "<Object Naming Prefix>"
  ```

- **Azure wide Variables:**
  ```hcl
  azure-location = "<Azure Location>"
  docker-pub-key = "<ssh public key location>"
  ```

- **XC wide Variables:**
  ```hcl
  xc_app_domain = "<FQDN-DNS>"
  ```


