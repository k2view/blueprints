# K2view Site Deployment on Azure Kubernetes Service (AKS) using Terraform
This Terraform module is an example configuration for deploying a K2view site on Azure, specifically focusing on Azure Kubernetes Service (AKS) setup.

## Pre-requisites
1. Azure Account with Owner role in the relevant subscription.
2. Tarraform - [hashicorp install guide](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)
3. Azure cli - [az install guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
4. Helm - [Helm install](https://helm.sh/docs/intro/install/)
5. Kubectl - [Kubectl install](https://kubernetes.io/docs/tasks/tools/)
6. Mailbox id - K2view cloud manager mailbox id.
7. Domain - subdomain that can be poinded to the clester (A record of *.site.domain.com will point to the load balancer IP). 
8. TLS wildcard certificate - wildcard certificate for the domain (privkey.pem and fullchain.pem of *.site.domain.com).

## Create cluster example
### Initializing Terraform
Run the following command to initialize Terraform and download required providers:
```text
terraform init
```

### Creating an AKS Cluster
Copy [terraform.tfvars.template](./terraform.tfvars.template) to "terraform.tfvars" and fill the values.
```text
cp terraform.tfvars.template terraform.tfvars
```
Make sure to set the required variables.

Deploy your AKS cluster using the following Terraform commands:
```text
terraform plan -var-file=terraform.tfvars -out tfplan
terraform apply tfplan
```
**IMPORTANT**
To disable monitoring set "deploy_grafana_agent" to "false".
If you want to enable the monitoring, first [configure Grafana Cloud](#configure-grafana-monitoring)

### Configure grafana monitoring
To configure grafana monitoring ask K2view representative to generate a token and supply grafana agent configuration file.
Paste the configuration to [grafana-agent-values.yaml](./grafana-agent-values.yaml) and run ```terraform apply```

## Post-actions
After deploying the AKS cluster, perform the following actions:
* Push images to acr - Push all relevant images, including the Fabric image, to the Azure Container Registry (ACR) created by this Terraform module.
* Create DNS record -  Point your domain's DNS to the DNS zone that is created by this Terraform module (point *.site.domain.com to the LB).


## Providers
| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.97.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.13.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.27.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| <a name="module_AKS_ingress"></a> [AKS\_ingress](#module\_AKS\_ingress) | ../modules/ingress | n/a |
| <a name="module_AKS_k2v_agent"></a> [AKS\_k2v\_agent](#module\_AKS\_k2v\_agent) | ../modules/k2v_agent | n/a |
| <a name="module_AKS_private_network"></a> [AKS\_private\_network](#module\_AKS\_private\_network) | ../modules/private_network | n/a |
| <a name="module_DNS_zone"></a> [DNS\_zone](#module\_DNS\_zone) | ../modules/dns_zone | n/a |
| <a name="module_create_acr"></a> [create\_acr](#module\_create\_acr) | ../modules/acr | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.97.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.97.0/docs/resources/resource_group) | resource |
| [random_string.acr_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | ACR name in Azure (Resource names may contain alpha numeric characters only and must be between 5 and 50 characters, needs to be globally unique.) | `string` | `""` | no |
| <a name="input_certPath"></a> [certPath](#input\_certPath) | Path to the TLS cert file. | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AKS name in Azure | `string` | n/a | yes |
| <a name="input_create_acr"></a> [create\_acr](#input\_create\_acr) | Create ACR in Azure | `bool` | `true` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | Create DNS zone in Azure that point all the trafic to the LB | `bool` | `true` | no |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Create Vnet for the AKS cluster | `bool` | `true` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Create RG name in Azure | `bool` | `true` | no |
| <a name="input_delay_command"></a> [delay\_command](#input\_delay\_command) | The command for delay (depend on the env). | `string` | `"sleep 60"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | the domain will be used for ingress | `string` | n/a | yes |
| <a name="input_keyPath"></a> [keyPath](#input\_keyPath) | Path to the TLS key file. | `string` | `""` | no |
| <a name="input_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#input\_kubeconfig\_file\_path) | Path for kubeconfig file | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. | `string` | `"1.27.9"` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID. | `string` | `""` | no |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud mailbox URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum cluster size | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum cluster size | `number` | `1` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Private AKS | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | Virtual network subnet address prefixes CIDR | `string` | `"10.240.0.0/16"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Virtual network subnet ID for existing Vnet | `string` | `""` | no |
| <a name="input_system_node_count"></a> [system\_node\_count](#input\_system\_node\_count) | Number of AKS worker nodes (min\_size <= system\_node\_count <= max\_size). | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Virtual network address space CIDR | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | VM sku | `string` | `"Standard_D8s_v3"` | no |
| <a name="input_deploy_grafana_agent"></a> [deploy\_grafana\_agent](#input\_deploy\_grafana\_agent) | A boolean flag to control whether to install grafana agent | `boolean` | `"false"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | The admin password for the Azure Container Registry (ACR), marked as sensitive. |
| <a name="output_acr_user"></a> [acr\_user](#output\_acr\_user) | The username for the Azure Container Registry (ACR) created by the module. |
| <a name="output_dns_name_servers"></a> [dns\_name\_servers](#output\_dns\_name\_servers) | The list of name servers associated with the DNS zone created. |
| <a name="output_nginx_lb_ip"></a> [nginx\_lb\_ip](#output\_nginx\_lb\_ip) | The IP address of the load balancer associated with the Nginx ingress controller. |
