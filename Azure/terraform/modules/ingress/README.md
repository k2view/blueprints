# Deploy Nginx Ingress Controller with Terraform
This Terraform template is designed to deploy the Nginx ingress controller to a Kubernetes cluster. It simplifies the process of setting up a robust and scalable ingress solution for your Kubernetes applications.

## Usage
This submodule can be used to deploy an Nginx ingress controller into your Azure Kubernetes Service (AKS) cluster. Modify the following Terraform configuration to fit your specific requirements:
```hcl
module "AKS-ingress" {
  source        = "./modules/ingress"
  domain        = var.domain           # Domain for ingress routing
  keyPath       = var.keyPath          # Path to the TLS key file
  crtPath       = var.crtPath          # Path to the TLS cert file
}
```

## Providers
| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Resources
| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | the domain will be used for ingress | `string` | n/a | yes |
| <a name="keyPath"></a> [domain](#keyPath) | Path to the TLS key file. | `string` | n/a | yes |
| <a name="crtPath"></a> [domain](#crtPath) | Path to the TLS cert file. | `string` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_ingress_test_url"></a> [ingress\_test\_url](#output\_ingress\_test\_url) | "The URL of the test ingress to validate successful deployment." |
