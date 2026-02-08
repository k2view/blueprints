# nginx-ingress-controller
![Version: 1.3.6](https://img.shields.io/badge/Version-1.3.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.12.1](https://img.shields.io/badge/AppVersion-1.12.1-informational?style=flat-square)

An example Nginx ingress controller deployment for Kubernetes. This Helm chart demonstrates how to deploy and configure an Nginx ingress controller to manage HTTP and HTTPS traffic routing to services within the cluster. Configured as a reference implementation for the K2view site.

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespace.name | string | `"ingress-nginx"` | Namespace for the ingress controller |
| domain | string | `"site.cloud.k2view.com"` | Domain for the site, used for ingressTest and errorPage |
| provider | string | `"gcp"` | Cloud provider (gcp, aws, azure) |
| aws.awsDomainCert | string | `"arn"` | AWS domain certificate ARN for SSL |
| aws.vpcCIDR | string | `""` | AWS VPC CIDR for proxy-real-ip-cidr configuration |
| nginx.httpPort.enabled | bool | `true` | Enable HTTP port (port 80) |
| nginx.internal_lb | bool | `false` | Use internal load balancer instead of external |
| nginx.version | string | `"1.12.1"` | Version of the Nginx ingress controller |
| nginx.ingress_nginx_controller_image | string | `"registry.k8s.io/ingress-nginx/controller:v1.12.1@sha256:d2fbc4ec70d8aa2050dd91a91506e998765e86c96f32cffb56c503c9c34eed5b"` | Docker image for the Nginx ingress controller |
| nginx.kube_webhook_certgen_image | string | `"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.2@sha256:e8825994b7a2c7497375a9b945f386506ca6a3eda80b89b74ef2db743f66a5ea"` | Docker image for webhook certificate generation |
| tlsSecret.enabled | bool | `false` | Enable TLS secret configuration |
| tlsSecret.default_ssl_certificate | bool | `false` | Use as default SSL certificate for ingress controller |
| tlsSecret.keyPath | string | `""` | Path to the TLS private key file |
| tlsSecret.certPath | string | `""` | Path to the TLS certificate file |
| tlsSecret.key | string | `""` | TLS private key as string |
| tlsSecret.cert | string | `""` | TLS certificate as string |
| tlsSecret.key_b64 | string | `""` | Base64 encoded TLS private key |
| tlsSecret.cert_b64 | string | `""` | Base64 encoded TLS certificate |
| ingressTest.enabled | bool | `true` | Enable test pod that returns SUCCESS from ingress-test subdomain |
| errorPage.enabled | bool | `false` | Enable custom error pages (404, 503) served by dedicated pod |
| errorPage.image | string | `"registry.k8s.io/ingress-nginx/nginx-errors:v20230505@sha256:3600dcd1bbd0d05959bb01af4b272714e94d22d24a64e91838e7183c80e53f7f"` | Docker image for custom error pages |
| errorPage.secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com"` | K2 Manager URL link displayed on error pages |
| errorPageS3.enabled | bool | `true` | Enable custom error pages served from S3/CloudFront |
| errorPageS3.image | string | `"nginx:alpine"` | Docker image for S3 error page proxy |
| errorPageS3.cloudfron_url | string | `"https://dn37e3zom5xe1.cloudfront.net/index.html"` | CloudFront URL for error page content |
| errorPageS3.secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com"` | K2 Manager URL for S3-hosted error pages |

## Resources
### ingress-controller
Nginx ingress controller that manages HTTP/HTTPS traffic routing in the cluster. Supports provider-specific configurations for AWS, GCP, and Azure.

### 404-nginx-error-page
Deploy K2view custom error page that will replace the 404 and 503 error pages of nginx. This version serves static error pages from the pod itself.
>NOTE: To disable the error page, set `errorPage.enabled=false`

### 404-nginx-error-page-s3
Deploy K2view custom error page that proxies error pages from S3/CloudFront. This version fetches error page content from a CloudFront distribution.
>NOTE: To disable S3-hosted error pages, set `errorPageS3.enabled=false`

### test-pod
Test pod that returns the string 'SUCCESS' from `ingress-test.{{ .Values.domain }}`. Useful for verifying ingress configuration.
>NOTE: To disable the test pod, set `ingressTest.enabled=false`

### tls-secret
TLS secret for default SSL certificate for the Nginx controller. The certificate can be provided as a file path, string, or base64 encoded string.
>NOTE: To create a default SSL certificate, set `tlsSecret.default_ssl_certificate=true` and provide the key and cert using one of the available formats (keyPath/certPath, key/cert, or key_b64/cert_b64)

### restricted-sa
Restricted service account with minimal permissions for running nginx error page pods securely.

## References
Official Kubernetes ingress-nginx deployment manifests for cloud providers:
- [AWS deployment](https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/aws/deploy.yaml)
- [GCP deployment](https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/cloud/deploy.yaml)
- [Azure deployment](https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/cloud/deploy.yaml)

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
