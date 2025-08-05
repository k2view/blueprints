# Fabric Helm Chart

![Version: 1.2.19](https://img.shields.io/badge/Version-1.2.19-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.2.0](https://img.shields.io/badge/AppVersion-8.2.0-informational?style=flat-square)

## Overview

The Fabric Helm chart provides a robust, production-ready deployment of the Fabric application on Kubernetes clusters. This chart is designed for flexibility, security, and ease of use, supporting a wide range of configuration options to suit enterprise and cloud-native environments. It is suitable for both development and production deployments, and is maintained with best practices for reliability and scalability.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Add the Helm Repository (Remote Installation)](#1-add-the-helm-repository-remote-installation)
  - [2. Install the Chart from Remote Repository](#2-install-the-chart-from-remote-repository)
  - [3. Install the Chart Locally (After Cloning the Repo)](#3-install-the-chart-locally-after-cloning-the-repo)
  - [4. Custom Installation](#4-custom-installation)
- [Upgrading](#upgrading)
- [Uninstallation](#uninstallation)
- [Configuration](#configuration)
  - [Deployment Options](#deployment-options)
    - [1. Deployment (Recommended for Development/Studio)](#1-deployment-recommended-for-developmentstudio)
    - [2. StatefulSet (Recommended for Production/Server)](#2-statefulset-recommended-for-productionserver)
  - [Fabric Application Configuration](#fabric-application-configuration)
- [RBAC](#rbac)
- [Horizontal Pod Autoscaling (HPA)](#horizontal-pod-autoscaling-hpa)
- [Ingress](#ingress)
  - [Ingress Routing Types](#ingress-routing-types)
    - [1. Path-Based Routing (No Wildcard TLS - Recommended)](#1-path-based-routing-no-wildcard-tls---recommended)
    - [2. Domain-Based Routing (Wildcard TLS)](#2-domain-based-routing-wildcard-tls)
- [Storage (Persistence)](#storage-persistence)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)
- [Support](#support)


## Features

- **Configurable Deployments:** Easily customize replicas, resources, and environment variables.
- **Production-Ready Defaults:** Secure and scalable out-of-the-box settings.
- **Support for Ingress:** Integrate with popular ingress controllers for external access, including:
  - **NGINX Ingress Controller** (default, fully supported)
  - **AWS ALB Ingress Controller** (annotation changes may be required)
  - **Azure Application Gateway Ingress Controller (AGIC)** (annotation changes may be required)
  - **GCE Ingress Controller** (annotation changes may be required)
  
  > Note: Some ingress controllers may require minor changes to annotations or configuration. Refer to the documentation of your chosen ingress controller for details.
- **Persistent Storage:** Optional persistent volume claims for data durability.
- **Customizable Service Exposure:** Choose between ClusterIP, NodePort, or LoadBalancer.
- **Health Checks:** Liveness and readiness probes for robust operation.
- **Resource Management:** Fine-grained control over CPU and memory requests/limits.
- **Secrets Management:** Integrate with Kubernetes secrets for sensitive data.
- **Extensible:** Easily override or extend with your own values files.

## Prerequisites

- Kubernetes 1.27+
- Helm 3.0+
- Ingress controller (e.g., NGINX)

## Installation


### 1. Add the Helm Repository (Remote Installation)

```sh
helm repo add fabric https://nexus.share.cloud.k2view.com/repository/fabric/
helm repo update
```

### 2. Install the Chart from Remote Repository

```sh
helm install SPACE_NAME fabric/fabric \
  --namespace SPACE_NAME \
  --create-namespace
```

### 3. Install the Chart Locally (After Cloning the Repo)

If you have cloned this repository, you can install the chart directly from the local directory:

```sh
cd helm/charts/fabric
helm install SPACE_NAME . \
  --namespace SPACE_NAME \
  --create-namespace
```

### 4. Custom Installation

You can override default values using a custom `values.yaml` file:

```sh
# For remote installation
helm install SPACE_NAME fabric/fabric -f my-values.yaml
# For local installation
helm install SPACE_NAME . -f my-values.yaml
```

## Upgrading

To upgrade an existing release:

```sh
helm upgrade SPACE_NAME fabric/fabric -f my-values.yaml
```

## Uninstallation

To uninstall the release:

```sh
helm uninstall SPACE_NAME
```

## Configuration


The following table lists the main configurable parameters of the Fabric chart and their default values. For a full list and detailed descriptions, see `values.yaml` in the chart directory.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `global.labels` | object | `[]` | Additional global labels to add to resources |
| `namespace.create` | bool | `false` | Whether to create the namespace |
| `namespace.name` | string | `"space-tenant"` | Namespace to deploy into |
| `deploy.type` | string | `Deployment` | Deployment type (`Deployment` or `StatefulSet`) |
| `serviceAccount.create` | bool | `true` | Create a new service account |
| `serviceAccount.name` | string | `""` | Name of the service account (empty for new) |
| `serviceAccount.provider` | string | `""` | Cloud provider for service account |
| `serviceAccount.arn` | string | `""` | AWS IAM role ARN |
| `serviceAccount.project_id` | string | `""` | GCP project ID |
| `serviceAccount.cluster_name` | string | `""` | Cluster name |
| `serviceAccount.azure_client_id` | string | `""` | Azure Managed Identity client ID |
| `container.replicas` | int | `1` | Number of Fabric pods |
| `container.annotationsList` | list | `[{{name: description, value: Fabric on Kubernetes}}]` | List of pod annotations |
| `container.resource_allocation.limits.memory` | string | `8Gi` | Memory limit |
| `container.resource_allocation.limits.cpu` | string | `2` | CPU limit |
| `container.resource_allocation.requests.memory` | string | `2Gi` | Memory request |
| `container.resource_allocation.requests.cpu` | string | `0.4` | CPU request |
| `container.image.url` | string | `""` | Fabric image URL |
| `container.image.repoSecret.name` | string | `registry-secret` | Image pull secret name |
| `container.image.repoSecret.enabled` | bool | `false` | Enable image pull secret |
| `storage.pvc.enabled` | bool | `true` | Enable persistent volume claim |
| `storage.securityContext` | bool | `true` | Enable pod security context |
| `storage.class` | string | `managed` | Storage class name |
| `storage.alocated_amount` | string | `10Gi` | PVC size |
| `scaling.enabled` | bool | `false` | Enable autoscaling |
| `scaling.minReplicas` | int | `1` | Minimum replicas for autoscaling |
| `scaling.maxReplicas` | int | `1` | Maximum replicas for autoscaling |
| `scaling.targetCPU` | int | `90` | Target CPU utilization for HPA |
| `networkPolicy.egress.enabled` | bool | `false` | Enable egress network policy |
| `networkPolicy.ingress.enabled` | bool | `false` | Enable ingress network policy |
| `ingress.enabled` | bool | `true` | Enable ingress |
| `ingress.class_name` | string | `nginx` | Ingress class name |
| `ingress.type` | string | `nginx` | Ingress type |
| `ingress.host` | string | `space-tenant.domain` | Ingress host |
| `ingress.path` | bool/string | `false` | Boolean true uses same value as namespace or hardcoded "string" |
| `ingress.subdomain` | bool/string | `false` | Boolean true uses same value as namespace or hardcoded "string" |
| `ingress.appgw_ssl_certificate_name` | string | `""` | Azure Application Gateway SSL certificate name |
| `ingress.tlsSecret.enabled` | bool | `false` | Enable TLS secret for ingress |
| `ingress.cert_manager.enabled` | bool | `false` | Enable cert-manager integration |
| `ingress.cert_manager.cluster_issuer` | string | `""` | cert-manager ClusterIssuer name |
| `ingress.custom_annotations.enabled` | bool | `false` | Enable custom ingress annotations |
| `ingress.custom_annotations.annotations` | list | See `values.yaml` | Custom ingress annotations |
| `mountSecret.enabled` | bool | `false` | Mount decoded secret to pod |
| `mountSecret.name` | string | `config-secrets` | Name of the secret to mount |
| `mountSecret.mountPath` | string | `/opt/apps/fabric/config-secrets` | Path to mount the secret |
| `mountSecret.data` | object | See `values.yaml` | Data to mount as secret (see config, cp_files, idp_cert) |
| `mountSecretB64enc.enabled` | bool | `false` | Mount base64-encoded secret to pod |
| `mountSecretB64enc.name` | string | `mount-b64-secrets` | Name of the base64 secret to mount |
| `mountSecretB64enc.mountPath` | string | `/opt/apps/fabric/config-secrets` | Path to mount the base64 secret |
| `mountSecretB64enc.data` | object | See `values.yaml` | Data to mount as base64 secret |
| `secretsList` | list | `[]` | List of additional secrets (see structure in values.yaml) |
| `initSecretsList` | list | `[]` | List of init container secrets (see structure in values.yaml) |
| `affinity.type` | string | `none` | Pod affinity/anti-affinity/none |
| `affinity.label.name` | string | `topology.kubernetes.io/zone` | Affinity label name |
| `affinity.label.value` | string | `region-a` | Affinity label value |

> **Tip:** For advanced configuration and secret formats, refer to the comments in `values.yaml`.

### Deployment Options

The Fabric Helm Chart supports two deployment types, each suited for different environments and use cases:

#### 1. Deployment (Recommended for Development/Studio)
Use this mode for development environments or when running Fabric Studio. This mode is stateless and works __only__ in a __single-replica__ setup.

**Recommended configuration:**
- `deploy.type: Deployment`
- `container.replicas: 1`
- `storage.pvc.enabled: true`

#### 2. StatefulSet (Recommended for Production/Server)
Use this mode for staging or production environments, or when running Fabric Server. This mode is designed for stateful workloads and high availability.

**Recommended configuration:**
- `deploy.type: StatefulSet`
- `storage.pvc.enabled: false` (shared PVC is not recommended for multiple replicas)
- Set `container.replicas` to the desired number of server instances

> **Note:**
> - For most production scenarios, use StatefulSet with persistent storage managed outside the pod (e.g., cloud-native databases, object storage).
> - Only use a shared PVC (`storage.pvc.enabled: true`) if your storage class supports multi-attach and your use case requires it.


### Fabric Application Configuration

The Fabric application is configured via the `config.ini` file, which is managed through the `mountSecret.data.config` variable in your `values.yaml`.

To customize the application configuration:
- Edit the `mountSecret.data.config` field in your `values.yaml` file.
- Provide your configuration in standard INI format, with sections and key-value pairs.

**Example:**
```ini
[fabric]
WEB_SESSION_EXPIRATION_TIME_OUT=540
ENABLE_BROADWAY_DEBUG_SERVLET=true

[system_db]
SYSTEM_DB_TYPE=SQLITE
SYSTEM_DB_HOST=/opt/apps/fabric/workspace/internal_db

# Add additional sections and keys as needed
```

> **Tip:** See the default `values.yaml` for more configuration examples and comments. Changes to this section will be reflected in the Fabric application's runtime configuration under `/opt/apps/fabric/workspace/config/config.ini`.


## RBAC

RBAC (Role-Based Access Control) in this Helm chart is managed via the `serviceAccount` section in your `values.yaml` file.

- If `serviceAccount.create: true`, a dedicated Kubernetes ServiceAccount will be created in the Fabric namespace and automatically associated with the Fabric pods.
- If `serviceAccount.create: false`, you must specify the name of an existing ServiceAccount to use.

This mechanism is especially useful in cloud environments to enable IAM-based access to cloud resources (such as AWS IAM Roles for Service Accounts, GCP Workload Identity, or Azure Managed Identity).

To enable cloud provider integration for IAM-based access, set the `serviceAccount.provider` field to one of the supported values:

| Provider | Value for `serviceAccount.provider` | Additional Required Fields |
|----------|-------------------------------|----------------------------|
| AWS      | `aws`                         | `arn` (IAM Role ARN)       |
| GCP      | `gcp`                         | `gcp_service_account_name` or `project_id` + `cluster_name` |
| Azure    | `azure`                       | `azure_client_id`          |

Refer to the comments in `values.yaml` for detailed configuration examples for each cloud provider.

## Horizontal Pod Autoscaling (HPA)

Horizontal Pod Autoscaling (HPA) is managed via the `scaling` section in your `values.yaml` file.

To enable HPA:
- Set `scaling.enabled: true`
- Adjust `scaling.minReplicas` and `scaling.maxReplicas` to define the allowed range of pod replicas
- Set `scaling.targetCPU` to the target average CPU utilization percentage that will trigger scaling

**Example:**
```yaml
scaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
  targetCPU: 80
```

> **Note:**
> - HPA requires resource requests and limits to be set for CPU in your container configuration.
> - The chart will automatically create the necessary Kubernetes HPA resource when enabled.

## Ingress

To enable ingress, set `ingress.enabled: true` and configure the hostname:

```yaml
ingress:
  enabled: true
  class_name: "nginx"
  type: "nginx"
  host: fabric.example.com
  tlsSecret:
    enabled: false
  cert_manager:
    enabled: false
  custom_annotations:
    enabled: false
    annotations:
      - key: nginx.ingress.kubernetes.io/proxy-body-size
        value: "0"
```


### Ingress Routing Types


The Fabric Helm chart supports two primary ingress routing strategies, allowing flexibility based on your domain and certificate setup. The routing logic is controlled by the `ingress.path` and `ingress.subdomain` parameters:

- `ingress.path`: If set to `true`, the path will be set to the namespace name. If set to a string, that string will be used as the path. If set to `false`, path-based routing is disabled.
- `ingress.subdomain`: If set to `true`, the subdomain will be set to the namespace name. If set to a string, that string will be used as the subdomain. If set to `false`, subdomain-based routing is disabled.

This allows for flexible ingress host and path generation, supporting both domain-based and path-based routing, as well as custom values for advanced scenarios.

**Summary:**
- Use `ingress.subdomain` for subdomain-based routing (e.g., `space-tenant.domain`).
- Use `ingress.path` for path-based routing (e.g., `domain/space-tenant`).
- You can set either to `true` (use namespace), a string (custom value), or `false` (disable).

Below are the two most common routing strategies: 1. Path-Based Routing (No Wildcard TLS - Recommended) and 2. Domain-Based Routing (Wildcard TLS)

#### 1. Path-Based Routing (No Wildcard TLS - Recommended)
Use this method if you do not have a wildcard TLS certificate. Each space is accessed via a unique path on a shared domain (e.g., `domain/space-tenant`). This is the recommended configuration.

- **Ingress host:** Static (e.g., `domain`)
- **Ingress path:** Dynamic (per space)

**How to use:**
- Set `ingress.host` to your domain (e.g., `domain`)
- Set `ingress.path` to the space name (e.g., `space-tenant`)
- Optional: set `ingress.path` to `true` to use namespace name as a path prefix

**Example values.yaml:**
```yaml
ingress:
  enabled: true
  host: domain
  path: space-tenant
  # ...other values...
```

**Resulting Ingress manifest:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fabric-ingress
  namespace: space-tenant
  labels:
    app: fabric
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "86400"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "900"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - domain
  rules:
    - host: domain
      http:
        paths:
          - path: /space-tenant
            pathType: Prefix
            backend:
              service:
                name: fabric-service
                port:
                  number: 3213
```

> **Note:**
> - Choose the routing type that matches your certificate and DNS setup.
> - The chart templates are designed to support both strategies out-of-the-box.
> - For advanced ingress controller features or custom annotations, refer to your ingress controller's documentation.

#### 2. Domain-Based Routing (Wildcard TLS)
This method is recommended when you have a wildcard TLS certificate for your domain. Each space is accessed via a subdomain (e.g., `space-tenant.domain`).

- **Ingress host:** Dynamic (per space, as subdomain)
- **Ingress path:** Static (`/`)

**How to use:**
- Set `ingress.host` to the subdomain (e.g., `space-tenant.domain`)
- Set `ingress.path` to `/` or leave it blank (default)
- Optional: set `ingress.subdomain` to `true` to use namespace name as subdomain

**Example values.yaml:**
```yaml
ingress:
  enabled: true
  host: space-tenant.domain
  # ...other values...
```

**Resulting Ingress manifest:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fabric-ingress
  namespace: space-tenant
  labels:
    app: fabric
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "86400"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "900"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - space-tenant.domain
  rules:
    - host: space-tenant.domain
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: fabric-service
                port:
                  number: 3213
```


## Storage (Persistence)


To enable persistent storage, configure the following:

```yaml
storage:
  pvc:
    enabled: true
  class: managed
  alocated_amount: 20Gi
  securityContext: true
```

> **Note:**
> Enabling `pvc.enabled: true` will create a shared PersistentVolumeClaim (PVC) for the deployment. In multi-node or highly available setups, this is generally not recommended when running more than one replica, as most storage classes do not support multi-node (ReadWriteMany) access and most use cases do not require shared storage. For most deployments with `replica` count above 1, set `pvc.enabled: false` unless you have a specific need and your storage class supports multi-attach.

## Environment Variables

You can set environment variables for fabric by adding them under secretsList.data in values.yaml:

```yaml
secretsList:
  - name: common-env-secrets
    data:
      MY_ENV_VAR_1: 'VALUE_1'
      MY_ENV_VAR_2: 'VALUE_2'
```

## Troubleshooting

- Check pod logs: `kubectl logs <pod-name> -n fabric`
- Describe resources: `kubectl describe pod <pod-name> -n fabric`
- Verify ingress and service endpoints.

## Support

For issues, questions, or feature requests, please contact your Fabric support representative, email us at [support@k2view.com](mailto:support@k2view.com), or open an issue in the official repository.
