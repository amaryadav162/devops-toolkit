# devops-toolkit

## Overview

This repository contains an Azure Infrastructure-as-Code project using Terraform modules to provision:
- Azure Resource Group
- Azure Virtual Network
- Azure Subnets
- Azure Public IP addresses
- Azure Linux Virtual Machines

The deployment is configured from `Enviroment/preprod` and uses reusable modules defined under `modules/`.

## Repository Structure

- `Enviroment/preprod/`
  - `main.tf` — instantiates the Terraform modules for the preprod environment.
  - `provider.tf` — configures the AzureRM provider.
  - `terraform.tfvars` — environment-specific module input values.
  - `variable.tf` — declares variables used by the environment layer.

- `modules/azurerm_resource_group/`
  - `main.tf` — creates Azure Resource Groups.
  - `variable.tf` — declares `rgs`.

- `modules/azurerm_virtual_network/`
  - `main.tf` — creates Azure Virtual Networks.
  - `variable.tf` — declares `vnets`.

- `modules/azurerm_subnet/`
  - `main.tf` — creates Azure Subnets.
  - `variable.tf` — declares `subnets`.

- `modules/azurerm_public_ip/`
  - `main.tf` — creates Azure Public IPs.
  - `variable.tf` — declares `public_ips`.

- `modules/azurerm_virtual_machine/`
  - `data.tf` — looks up existing subnets and public IPs.
  - `main.tf` — creates Azure network interfaces and Linux VMs.
  - `variable.tf` — declares `vms`.

## Azure Provider

The environment config uses:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## How It Works

The `Enviroment/preprod/main.tf` file creates resources in this order:
1. Resource groups
2. Virtual networks
3. Subnets
4. Public IPs
5. Virtual machines

The VM module uses data sources to resolve:
- subnet by name
- public IP by name

## Example Variables

The current `Enviroment/preprod/terraform.tfvars` defines:
- one resource group: `rg-tin`
- one virtual network: `rg-tivnet`
- two subnets: `frontend-subnet`, `backend-subnet`
- two static public IP addresses
- two Linux VMs with password authentication enabled

> Note: The VMs use Ubuntu 16.04 LTS as the source image.

## Usage

1. Authenticate with Azure:
   - `az login`

2. Initialize Terraform:
   - `terraform init`

3. Validate configuration:
   - `terraform validate`

4. Preview the changes:
   - `terraform plan -var-file=Enviroment/preprod/terraform.tfvars`

5. Apply the deployment:
   - `terraform apply -var-file=Enviroment/preprod/terraform.tfvars`

## Notes

- Keep `terraform.tfstate` and `terraform.tfstate.backup` secure.
- Avoid committing sensitive values such as passwords into source control.
- If you want to deploy a different environment, duplicate `Enviroment/preprod/` and update the variable values.

## Improvements

Potential enhancements include:
- adding `output` blocks for VM IDs, IP addresses, and network details
- using SSH key authentication instead of passwords
- adding environment-specific backend configuration for remote state
- splitting variables into separate files for readability
