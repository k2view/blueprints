# Cert guard identity

This module handles the creation of Azure and assigns specified IAM roles.

## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Resources
| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.cert_guardian_identity_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.cert_guardian_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.cert_guardian_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_dns_zone.azure_dns_managed](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Azure DNS zone name, required | `string` | `""` | no |
| <a name="input_identity_name"></a> [identity\_name](#input\_identity\_name) | Identity name | `string` | `"cert-guardian"` | no |
| <a name="input_kubernetes_oidc_issuer_url"></a> [kubernetes\_oidc\_issuer\_url](#input\_kubernetes\_oidc\_issuer\_url) | K8s Cluster OIDC Issuer URL, required | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Resource region | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | K8s service namespace | `string` | `"ingress-nginx"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure resource group name | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | K8s service account name | `string` | `"k2view-cert-guardian-sa"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription id in Azure | `string` | `""` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_managed_user_client_id"></a> [managed\_user\_client\_id](#output\_managed\_user\_client\_id) | The Client ID of the Cert Guardian identity, required for the helm charts deployment. |
