# nginx-ingress-controller

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.9.6](https://img.shields.io/badge/AppVersion-1.9.6-informational?style=flat-square)

This Helm chart deploys the Nginx ingress controller in a Kubernetes environment, tailored for the K2view site. The Nginx ingress controller provides a robust, flexible gateway for managing inbound HTTP/S traffic to your Kubernetes services.

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.awsDomainCert | string | `"arn"` | The ARN of the AWS certificate to be used for domain validation. |
| aws.vpcCIDR | string | `""` | The CIDR block for the AWS VPC. Specify this to restrict network access within the specified range. |
| errorPage.enabled | bool | `true` | Determines whether custom error pages are enabled. Set to false to disable. |
| errorPage.image | string | `"gcr.io/k2view-rnd/infra/cloud_dev404:0.4"` | The Docker image used for custom error pages. |
| errorPage.resource_allocation.limits.cpu | string | `"0.4"` | Sets the maximum CPU limit for the error page container. |
| errorPage.resource_allocation.limits.memory | string | `"256Mi"` | Sets the maximum memory limit for the error page container. |
| errorPage.resource_allocation.requests.cpu | string | `"0.1"` | The amount of CPU requested for the error page container. |
| errorPage.resource_allocation.requests.memory | string | `"128Mi"` | The amount of memory requested for the error page container. |
| errorPage.secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com"` | The URL for the K2 manager, used in the error page configuration. |
| ingressTest.domain | string | `"site.cloud.k2view.com"` | The domain used for ingress testing. |
| ingressTest.enabled | bool | `true` | Enable or disable ingress testing. |
| namespace.name | string | `"ingress-nginx"` | The Kubernetes namespace where the ingress controller will be deployed. |
| nginx.ingress_nginx_controller_image | string | `"registry.k8s.io/ingress-nginx/controller:v1.9.6@sha256:1405cc613bd95b2c6edd8b2a152510ae91c7e62aea4698500d23b2145960ab9c"` | The Docker image for the Nginx ingress controller. |
| nginx.kube_webhook_certgen_image | string | `"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20231226-1a7112e06@sha256:25d6a5f11211cc5c3f9f2bf552b585374af287b4debf693cacbe2da47daa5084"` | The Docker image for the Kubernetes webhook certificate generator. |
| nginx.version | string | `"1.9.6"` | The version of the Nginx ingress controller. |
| provider | string | `"gcp"` | Specifies the cloud provider where Kubernetes is hosted, e.g., GCP, AWS. |
| tlsSecret.enabled | bool | `false` | Enable or disable TLS secret creation. |
| tlsSecret.default_ssl_certificate | bool | `false` | Enable to use a default SSL certificate for the ingress. |
| tlsSecret.crtPath | string | `""` | Path to the TLS certificate file. Required if tlsSecret.enabled is true. |
| tlsSecret.keyPath | string | `""` | Path to the TLS key file. Required if tlsSecret.enabled is true. |
