# aks module
This module creates an AKS cluster with a system-assigned managed identity, autoscaling node pool, and workload identity / OIDC issuer enabled. Optionally attaches an ACR by granting the cluster's kubelet identity the AcrPull role.

## Usage
```hcl
module "aks" {
  source              = "../modules/azure/aks"
  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.vnet.subnet_id
  acr_id              = module.acr.acr_id
  kubernetes_version  = "1.34"
  min_size            = 1
  max_size            = 3
  tags                = var.tags
}
```

> **Note:** Setting `private_cluster_enabled = true` makes the API server reachable only within the VNet. Helm-based modules (ingress controller, k2view-agent) will fail and must be deployed separately.

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources
| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_role_assignment.role_acrpull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the AKS cluster. Also used as the DNS prefix. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Azure resource group that will contain the AKS cluster. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the cluster will be created (e.g. `West Europe`). | `string` | `"West Europe"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Resource ID of the existing VNet subnet to attach the node pool to. | `string` | `""` | no |
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | Resource ID of the ACR to grant AcrPull access to via the kubelet managed identity. | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the cluster (e.g. `1.34`). | `string` | `"1.34"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | AKS cluster SKU tier. Options: `Free`, `Standard`, `Premium`. | `string` | `"Standard"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones for the default node pool. | `list(number)` | `[1, 2]` | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | Azure VM size for the default node pool (e.g. `Standard_D8s_v3`). | `string` | `"Standard_D8s_v3"` | no |
| <a name="input_system_node_count"></a> [system\_node\_count](#input\_system\_node\_count) | Initial node count. Ignored after creation as autoscaling manages the count. | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of nodes the autoscaler can scale down to. | `number` | `1` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of nodes the autoscaler can scale up to. | `number` | `3` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | Outbound routing type. Options: `loadBalancer` (AKS default), `userAssignedNATGateway`, `userDefinedRouting`. | `string` | `"userAssignedNATGateway"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | When true, the API server is only reachable from within the VNet. | `bool` | `false` | no |
| <a name="input_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#input\_kubeconfig\_file\_path) | Local path to write the kubeconfig file. Leave empty to skip. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(any)` | `{"Env":"Dev","Owner":"owner_name","Project":"k2v_cloud"}` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Principal ID of the cluster's system-assigned managed identity. |
| <a name="output_host"></a> [host](#output\_host) | AKS API server endpoint. Used to configure the Kubernetes and Helm providers. |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Base64-encoded client certificate for authenticating to the AKS API server. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Base64-encoded client private key for authenticating to the AKS API server. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Base64-encoded cluster CA certificate. |
| <a name="output_cluster_oidc_url"></a> [cluster\_oidc\_url](#output\_cluster\_oidc\_url) | OIDC issuer URL of the cluster. Required for workload identity federation. |
