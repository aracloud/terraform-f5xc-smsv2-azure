# F5 SaaS Customer Edge (CE) with Public IP Assignment (Usable for All Normal Use Cases)

## Overview
This Terraform project deploys a single Azure virtual machine (VMs) integrated with F5 SaaS
using single NIC configuration and a docker host in **Azure** with a demo application (DVWA)
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
- SSH public key for Docker Host VM (adminuser) authentication
- A DNS config in F5 SaaS for proper service deplyoment (DNS Delegation or Zone Managment for Autocert in F5 SaaS)

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
├── terraform.tfvars.example
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

"export" the env variables to authenticate via terraform:

```
export VES_P12_PASSWORD=<P12_cert_password>
export VOLT_API_URL=https://f5-emea-ent.console.ves.volterra.io/api
export VOLT_API_P12_FILE=/path/to/the/p12/file_api-creds.p12
```


### 3. Update Variables

#### Modify `terraform.tfvars`
```bash
cp terraform.tfvars.example terraform.tfvars
```
Update the values in `terraform.tfvars` to match your deployment needs.

Here are some key variables to configure:

- **Planet wide Variables:**
  ```hcl
  prefix = "your-prefix"
  ```

- **Azure wide Variables:**
  ```hcl
  azure-location = "westus"
  tag_owner = "your-email"
  tag_source_host = "your-host"
  docker-pub-key = "your-machines-ssh-public-key"
  ```

- **XC wide Variables:**
  ```hcl
  xc_tenant = "your-tenant"
  xc_namespace = "your-namespace"
  xc_app_domain = "your-app-fqdn"
  ```

### 4. Initialize Terraform

Run the following command to initialize Terraform and download required providers:

```bash
terraform init
```

### 5. Plan the Deployment

Verify the configuration by running:

```bash
terraform plan
```

This command shows the resources Terraform will create.

### 6. Deploy the Resources

Apply the configuration to create resources in Azure:

```bash
terraform apply
```

Type `yes` to confirm the deployment or add the argument `--auto-approve`.

---

## Cleanup

To destroy all resources created by this project, run:

```bash
terraform destroy
```

Type `yes` to confirm the deletion or add the argument `--auto-approve`.

---
