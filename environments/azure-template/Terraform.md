## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azure"></a> [azure](#provider\_azure) | "=4.3.0" |


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | [../modules/azure/acr](../modules/azure/acr) | n/a |
| <a name="module_aks"></a> [aks](#module\_aks) | [../modules/azure/aks](../modules/azure/aks) | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | [../modules/azure/network/dns](../modules/azure/network/dns) | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | [../modules/azure/iam](../modules/azure/iam) | n/a |
| <a name="module_ingress-controller"></a> [ingress-controller](#module\_ingress-controller) | [../modules/shared/ingress-controller](../modules/shared/ingress-controller) | n/a |
| <a name="module_k2view-agent"></a> [k2view-agent](#module\_k2view-agent) | [../modules/shared/k2view-agent](../modules/shared/k2view-agent) | n/a |
| <a name="module_private-network"></a> [private-network](#module\_private-network) | [../modules/azure/network/private-network](../modules/azure/network/private-network) | n/a |
| <a name="module_resource-group"></a> [resource-group](#module\_resource-group) | [../modules/azure/resource-group](../modules/azure/resource-group) | n/a |
| <a name="module_storage-account"></a> [storage-account](#module\_storage-account) | [../modules/azure/storage-account](../modules/azure/storage-account) | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application.ebs_csi](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application.efs_csi](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.ebs_csi](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.efs_csi](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ebs_csi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.efs_csi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_network.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_node_pool.workers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_node_pool) | resource |
| [azurerm_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_dns_a_record.dns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/efs_file_system) | resource |
| [azurerm_managed_disk.ebs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [kubernetes_storage_class.ebs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_deployment.ingress_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.k2view_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | ACR name in Azure (Resource names may contain alpha numeric characters only and must be between 5 and 50 characters, needs to be globally unique.) | `string` | `""` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Provider | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AKS name in Azure | `string` | `""` | no |
| <a name="input_create_acr"></a> [create\_acr](#input\_create\_acr) | Create ACR in Azure | `bool` | `true` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | Create DNS zone in Azure that point all the trafic to the LB | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Create NAT gateway. | `bool` | `true` | no |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Create Vnet for the AKS cluster | `bool` | `true` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Create RG name in Azure | `bool` | `true` | no |
| <a name="input_create_route_table"></a> [create\_route\_table](#input\_create\_route\_table) | Create route table as a gateway. | `bool` | `false` | no |
| <a name="input_delay_command"></a> [delay\_command](#input\_delay\_command) | The command for delay (depend on the env). | `string` | `"sleep 60"` | no |
| <a name="input_deploy_ingress"></a> [deploy\_ingress](#input\_deploy\_ingress) | Deploy nginx ingress in the cluster | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for ingress | `string` | n/a | yes |
| <a name="input_ingress_controller_cert_b64"></a> [ingress\_controller\_cert\_b64](#input\_ingress\_controller\_cert\_b64) | Ingress Controller TLS certificate base64 encoded | `string` | `""` | no |
| <a name="input_ingress_controller_enable_private_lb"></a> [ingress\_controller\_enable\_private\_lb](#input\_ingress\_controller\_enable\_private\_lb) | Flag to enable or disable private load balancer IP | `bool` | `false` | no |
| <a name="input_ingress_controller_key_b64"></a> [ingress\_controller\_key\_b64](#input\_ingress\_controller\_key\_b64) | Ingress Controller TLS key base64 encoded | `string` | `""` | no |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view\_agent\_namespace) | The name of K2view agent namespace | `string` | `"k2view-agent"` | no |
| <a name="input_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#input\_kubeconfig\_file\_path) | Path for kubeconfig file | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. | `string` | `"1.30"` | no |
| <a name="input_lb_ip"></a> [lb\_ip](#input\_lb\_ip) | LB IP for the DNS to point to | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Resources location in Azure | `string` | `"West Europe"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID. | `string` | `""` | no |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud mailbox URL. | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum cluster size | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum cluster size | `number` | `1` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | Kubernetes version. | `string` | `"userAssignedNATGateway"` | no |
| <a name="input_prefix_name"></a> [prefix\_name](#input\_prefix\_name) | Prefix name for networks | `string` | `""` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | hould this Kubernetes Cluster have its API server only exposed on internal IP addresses? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_route_table_next_hop_ip"></a> [route\_table\_next\_hop\_ip](#input\_route\_table\_next\_hop\_ip) | IP address of the next hop in the routing table. | `string` | `""` | no |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | Virtual network subnet address prefixes CIDR | `string` | `"10.240.0.0/16"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Virtual network subnet ID for existing Vnet | `string` | `""` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `string` | n/a | yes |
| <a name="input_system_node_count"></a> [system\_node\_count](#input\_system\_node\_count) | Number of AKS worker nodes (min\_size <= system\_node\_count <= max\_size). | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags value | `map(any)` | <pre>{<br>  "Env": "Dev",<br>  "Owner": "k2view",<br>  "Project": "k2vDev"<br>}</pre> | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `string` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Virtual network address space CIDR | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | VM sku | `string` | `"Standard_D8s_v3"` | no |
