# nginx-ingress-controller
![Version: 1.3.2](https://img.shields.io/badge/Version-1.3.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.12.1](https://img.shields.io/badge/AppVersion-1.12.1-informational?style=flat-square)

This Helm chart is designed to deploy an Nginx ingress controller in a Kubernetes environment. This controller manages the routing of HTTP and HTTPS traffic to the appropriate services within the cluster. It is particularly configured for the K2view site, ensuring optimized performance and security.

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.awsDomainCert | string | `"arn"` | AWS domain certificate ARN |
| aws.vpcCIDR | string | `""` | AWS VPC CIDR |
| domain | string | `"site.cloud.k2view.com"` | Domain for the site, this parameter used for test page |
| errorPage.enabled | bool | `true` | Enable custom error pages |
| errorPage.image | string | `"registry.k8s.io/ingress-nginx/nginx-errors:v20230505"` | Docker image for custom error pages |
| errorPage.resource_allocation.limits.cpu | string | `"0.4"` | CPU limits for error page resources |
| errorPage.resource_allocation.limits.memory | string | `"256Mi"` | Memory limits for error page resources |
| errorPage.resource_allocation.requests.cpu | string | `"0.1"` | CPU requests for error page resources |
| errorPage.resource_allocation.requests.memory | string | `"128Mi"` | Memory requests for error page resources |
| errorPage.secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com"` | K2 Manager URL for error pages |
| ingressTest.enabled | bool | `true` | Enable ingress test |
| namespace.name | string | `"ingress-nginx"` | Namespace for the ingress controller |
| nginx.httpPort.enabled | bool | `true` | Enable HTTP port |
| nginx.ingress_nginx_controller_image | string | `"registry.k8s.io/ingress-nginx/controller:v1.12.1"` | Docker image for the Nginx ingress controller |
| nginx.internal_lb | bool | `false` | Use internal load balancer |
| nginx.kube_webhook_certgen_image | string | `"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.2"` | Docker image for webhook certificate generation |
| nginx.version | string | `"1.12.1"` | Version of the Nginx ingress controller |
| provider | string | `"gcp"` | Cloud provider (e.g., GCP, AWS) |
| tlsSecret.cert | string | `""` | TLS certificate |
| tlsSecret.certPath | string | `""` | Path to the TLS certificate |
| tlsSecret.cert_b64 | string | `""` | Base64 encoded TLS certificate |
| tlsSecret.default_ssl_certificate | bool | `false` | Use default SSL certificate |
| tlsSecret.enabled | bool | `false` | Enable TLS secret configuration |
| tlsSecret.key | string | `""` | TLS private key |
| tlsSecret.keyPath | string | `""` | Path to the TLS private key |
| tlsSecret.key_b64 | string | `""` | Base64 encoded TLS private key |

## Resources
### 404-nginx-error-page
Deploy k2view custom error page that will replace the 404 and 503 error pages of nginx
>NOTE: if you don't want to create the test pod set errorPage.enabled=false

### ingress-controller
Nginx controller

### test-pod
Test pod that will return string 'SUCCESS' from ingress-test.{{ .Values.domain }}
>NOTE: if you don't want to create the test pod set ingressTest.enabled=false

### tls-secret
TLS secret for default ssl certificate for the Nginx controller
>NOTE: to create default SSL certificate set tlsSecret.default_ssl_certificate=true and add the key and cert as a path, string or base64 string.

## Installation
### Install from helm repo
1. Add repo
```bash
helm repo add nginx-ingress-controller https://nexus.share.cloud.k2view.com/repository/nginx-ingress-controller
```

2. Install
```bash
helm install nginx-ingress-controller/nginx-ingress-controller nginx-ingress-controller
```

#### Example
```bash
helm install nginx-ingress-controller/nginx-ingress-controller nginx-ingress-controller --set tlsSecret.keyPath='secrets/key.pem',tlsSecret.certPath='secrets/cert.pem'
```
