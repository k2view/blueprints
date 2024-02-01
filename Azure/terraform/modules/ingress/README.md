# Deploy Nginx Ingress Controller with Terraform
This Terraform template is designed to deploy the Nginx ingress controller to a Kubernetes cluster. It simplifies the process of setting up a robust and scalable ingress solution for your Kubernetes applications.

## Usage
This submodule can be used to deploy an Nginx ingress controller into your Azure Kubernetes Service (AKS) cluster. Modify the following Terraform configuration to fit your specific requirements:
```hcl
module "AKS-ingress" {
  source        = "./modules/ingress"
  domain        = var.domain           # Domain for ingress routing
  cluster_name  = var.cluster_name     # Name of your AKS cluster
}
```

## Providers
| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources
| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.ingress_test](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.ingress_nginx_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.ingress_test](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_pod.ingress_test_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod) | resource |
| [kubernetes_service.ingress_test_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The AKS cluster name | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | the domain will be used for ingress | `string` | n/a | yes |
| <a name="input_nginx_namespace"></a> [nginx\_namespace](#input\_nginx\_namespace) | Kubernetes namespace for nginx | `string` | `"ingress-nginx"` | no |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_ingress_test_url"></a> [ingress\_test\_url](#output\_ingress\_test\_url) | "The URL of the test ingress to validate successful deployment." |
| <a name="nginx_lb_ip"></a> [nginx\_lb\_ip](#output\_nginx\_lb\_ip) | "The IP address of the load balancer for the Nginx ingress controller." |
