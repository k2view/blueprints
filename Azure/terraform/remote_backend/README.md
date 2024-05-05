# Remote Backend Module 

This Terraform module is designed to store your Terraform state file in a remote backend.

## Usage

To use this module for setting up a remote backend, include the following configuration in your Terraform script:

```hcl
module "remote_backend" {
  source                        = "../modules/remote_backend"
  resource_group_name           = var.resource_group_name
}
```

This configuration sets up storage account with a unique name and initializing a container to store the terraform.tfstate file.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.storage_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_storage_account.tfstate_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.tfstate_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create_resource_group](#input_create_resource_group) | Create RG in Azure | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | The name of the Azure Resource Group | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage_account_name](#input_storage_account_name) | The name of the storage account (only lowercase letters) | `string` | n/a | no |
| <a name="input_account_tier"></a> [account_tier](#input_account_tier) | The performance tier of the storage account | `string` | `"Standard"` | no |
| <a name="input_account_replication_type"></a> [account_replication_type](#input_account_replication_type) | The replication type of the storage account | `string` | `"GRS"` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags value for the resources | `map(string)` | `{ Env = "Dev", Owner = "k2view", Project = "k2vDev" }` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account_name"></a> [storage_account_name](#output_storage_account_name) | The name of the Azure Storage Account used to store Terraform states. |

## State Migration Process:

### Step 1: Enable Storage Account Creation

Set the `create_storage_account` variable to `true` in AKS folder - variables.tf file. This action enables the creation of an Azure Storage Account necessary for storing the state file remotely.

```hcl
create_storage_account = true
```

### Step 2: Initial Deployment

Perform the first deployment by following the steps in create cluster example section.

### Step 3: 

Configure the Remote Backend

1. Navigate to the file named backend.tf.template in AKS folder.
2. Rename the file to backend.tf.
3. Open backend.tf and fill in the relevant variables (e.g., resource_group_name, storage_account_name).

Example configuration snippet for backend.tf:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<resource-group-name>"
    storage_account_name = "<storage-account-name>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```
Replace placeholders with actual values corresponding to your Azure setup.

### Step 4: Reinitialize Terraform

To move the local state file to the configured remote backend, reinitialize Terraform:

```bash
terraform init
```

During initialization, Terraform will detect the change in the backend configuration. When prompted, confirm the migration of the state file to the new remote backend. This step is crucial for maintaining the state management consistency.