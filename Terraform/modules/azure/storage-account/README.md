# Azure Storage Account Module
Creates an Azure Storage account. By default the account name is derived from the cluster name (hyphens removed) with a `storageacc` suffix; set `account_name` to override it.

## Usage
```hcl
module "storage_account" {
  source = "./modules/azure/storage-account"

  cluster_name        = "my-aks-cluster"
  resource_group_name = "my-resource-group"
  location            = "West Europe"
}
```

## Requirements
| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Providers
| Name | Version |
|------|---------|
| [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) | >= 3.0 |

## Resources
| Name | Type |
|------|------|
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_name | Storage account name. If empty, derived from cluster_name (hyphens removed) with a `storageacc` suffix. Must be 3-24 lowercase alphanumeric characters and globally unique. | `string` | `""` | no |
| cluster_name | AKS cluster name (used to derive the storage account name) | `string` | `""` | no |
| resource_group_name | Azure resource group name | `string` | `""` | no |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| account_tier | Storage account performance tier (Standard or Premium) | `string` | `"Standard"` | no |
| account_replication_type | Storage account replication type (e.g. LRS, GRS, ZRS) | `string` | `"LRS"` | no |
| account_kind | Storage account kind (e.g. StorageV2, BlobStorage) | `string` | `"StorageV2"` | no |
