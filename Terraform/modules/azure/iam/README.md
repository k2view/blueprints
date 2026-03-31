# Azure IAM Module
Creates user-assigned managed identities for an AKS cluster and assigns the required Azure RBAC roles.

Two identities are provisioned:
- **Deployer identity** — used to deploy K2view spaces. Granted `Contributor` and `Managed Identity Contributor` on the resource group.
- **Space identity** — used by running spaces. Granted `Storage Blob Data Contributor` and `Key Vault Secrets User` on the resource group.

Additionally, the AKS cluster's managed identity is granted `Network Contributor` on the provided subnet.

## Usage
```hcl
module "iam" {
  source = "./modules/azure/iam"

  cluster_name              = "my-aks-cluster"
  resource_group_name       = "my-resource-group"
  location                  = "West Europe"
  aks_principal_id          = module.aks.principal_id
  subnet_id                 = module.network.subnet_id
  kubernetes_oidc_issuer_url = module.aks.oidc_issuer_url
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
| [azurerm_user_assigned_identity.deployer_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.space_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment.network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.deployer_identity_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.deployer_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.example_worker_blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.example_space_keyvault_secrets_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_resource_group.resource_group_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | AKS cluster name | `string` | n/a | yes |
| resource_group_name | Azure resource group name | `string` | n/a | yes |
| aks_principal_id | Principal ID of the AKS cluster's managed identity | `string` | n/a | yes |
| subnet_id | Subnet ID for the AKS cluster | `string` | n/a | yes |
| kubernetes_oidc_issuer_url | OIDC issuer URL of the AKS cluster (used for workload identity federation) | `string` | n/a | yes |
| location | Azure region for all resources | `string` | `"West Europe"` | no |
| k2view_agent_namespace | Kubernetes namespace for the K2view agent | `string` | `"k2view-agent"` | no |

## Outputs
| Name | Description |
|------|-------------|
| deployer_identity_client_id | Client ID of the deployer user-assigned managed identity |
| deployer_identity_id | Resource ID of the deployer user-assigned managed identity |
| space_identity_client_id | Client ID of the space user-assigned managed identity |
