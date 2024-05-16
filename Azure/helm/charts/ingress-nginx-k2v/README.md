# nginx-ingress-controller
![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.10.0](https://img.shields.io/badge/AppVersion-1.10.0-informational?style=flat-square)

This Helm chart deploys the Nginx ingress controller in a Kubernetes environment, tailored for the K2view site. The Nginx ingress controller provides a robust, flexible gateway for managing inbound HTTP/S traffic to your Kubernetes services.

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.awsDomainCert | string | `"arn"` |  |
| aws.vpcCIDR | string | `""` |  |
| domain | string | `"site.cloud.k2view.com"` |  |
| errorPage.enabled | bool | `true` |  |
| errorPage.image | string | `"registry.k8s.io/ingress-nginx/nginx-errors:v20230505@sha256:3600dcd1bbd0d05959bb01af4b272714e94d22d24a64e91838e7183c80e53f7f"` |  |
| errorPage.resource_allocation.limits.cpu | string | `"0.4"` |  |
| errorPage.resource_allocation.limits.memory | string | `"256Mi"` |  |
| errorPage.resource_allocation.requests.cpu | string | `"0.1"` |  |
| errorPage.resource_allocation.requests.memory | string | `"128Mi"` |  |
| errorPage.secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com"` |  |
| ingressTest.enabled | bool | `true` |  |
| namespace.name | string | `"ingress-nginx"` |  |
| nginx.httpPort.enabled | bool | `true` |  |
| nginx.ingress_nginx_controller_image | string | `"registry.k8s.io/ingress-nginx/controller:v1.10.0@sha256:42b3f0e5d0846876b1791cd3afeb5f1cbbe4259d6f35651dcc1b5c980925379c"` |  |
| nginx.internal_lb | bool | `false` |  |
| nginx.kube_webhook_certgen_image | string | `"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.0@sha256:44d1d0e9f19c63f58b380c5fddaca7cf22c7cee564adeff365225a5df5ef3334"` |  |
| nginx.version | string | `"1.10.0"` |  |
| provider | string | `"gcp"` |  |
| tlsSecret.cert | string | `""` |  |
| tlsSecret.certPath | string | `""` |  |
| tlsSecret.cert_b64 | string | `""` |  |
| tlsSecret.default_ssl_certificate | bool | `false` |  |
| tlsSecret.enabled | bool | `false` |  |
| tlsSecret.key | string | `""` |  |
| tlsSecret.keyPath | string | `""` |  |
| tlsSecret.key_b64 | string | `""` |  |
