# K2view site (AKS)
This terraform is a example of k2view site on Azure.

## Create cluster example
Run init
```text
terraform init
```

Create AKS cluster
```text
terraform plan -var-file=terraform.tfvars -out tfplan
terraform apply tfplan
```

## Post-actions
* Push images to acr - Push all relevant images (Fabric image) to thr ACR that created by this terraform.
* Create DNS record -  Point from your DNS to the DNS zone that created by this terraform.
* Install k2view agent - [k2view-agent](https://github.com/k2view/blueprints/tree/main/helm/k2view-agent)

## Requirements
Tarraform installed.
> [hashicorp install guide ](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

access to Azure
> [az install guide ](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.78.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.9.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.19.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.78.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| <a name="module_AKS_ingress"></a> [AKS\_ingress](#module\_AKS\_ingress) | ../modules/ingress | n/a |
| <a name="module_AKS_private_network"></a> [AKS\_private\_network](#module\_AKS\_private\_network) | ../modules/private_network | n/a |
| <a name="module_DNS_zone"></a> [DNS\_zone](#module\_DNS\_zone) | ../modules/dns_zone | n/a |
| <a name="module_create_acr"></a> [create\_acr](#module\_create\_acr) | ../modules/acr | n/a |

## Resources
| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/2.78.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.78.0/docs/resources/resource_group) | resource |
| [random_string.acr_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AKS name in Azure | `string` | n/a | yes |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Create RG name in Azure | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | the domain will be used for ingress | `string` | n/a | yes |
| <a name="input_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#input\_kubeconfig\_file\_path) | Path for kubeconfig file | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. | `string` | `"1.27.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum cluster size | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum cluster size | `number` | `1` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | Virtual network subnet address prefixes CIDR | `string` | `"10.240.0.0/16"` | no |
| <a name="input_system_node_count"></a> [system\_node\_count](#input\_system\_node\_count) | Number of AKS worker nodes (min\_size <= system\_node\_count <= max\_size). | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Virtual network address space CIDR | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | VM sku | `string` | `"Standard_D8s_v3"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | n/a |
| <a name="output_acr_user"></a> [acr\_user](#output\_acr\_user) | n/a |
| <a name="output_dns_name_servers"></a> [dns\_name\_servers](#output\_dns\_name\_servers) | n/a |
| <a name="output_nginx_lb_ip"></a> [nginx\_lb\_ip](#output\_nginx\_lb\_ip) | n/a |
