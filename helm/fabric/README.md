# Fabric Helm Chart
![Version: 1.2.41](https://img.shields.io/badge/Version-1.2.41-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.5](https://img.shields.io/badge/AppVersion-8.5-informational?style=flat-square)

## Overview
The Fabric Helm chart provides a deployment of the Fabric application on Kubernetes clusters. This chart is designed for flexibility, supporting a wide range of configuration options to suit enterprise and cloud-native environments. It is suitable for both development and production deployments.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Namespace Resolution](#namespace-resolution)
  - [1. Add the Helm Repository](#1-add-the-helm-repository)
  - [2. Install the Chart](#2-install-the-chart)
- [Upgrading](#upgrading)
- [Uninstallation](#uninstallation)
- [Configuration](#configuration)
  - [Deployment Options](#deployment-options)
    - [1. Deployment (Recommended for Development/Studio)](#1-deployment-recommended-for-developmentstudio)
    - [2. StatefulSet (Recommended for Production/Server)](#2-statefulset-recommended-for-productionserver)
  - [Fabric Application Configuration](#fabric-application-configuration)
- [Pod Initialization (init-fabric)](#pod-initialization-init-fabric)
  - [Environment Variables: secretsList and initSecretsList](#environment-variables-secretslist-and-initsecretslist)
  - [Mounted Secrets: mountSecret and mountSecretB64enc](#mounted-secrets-mountsecret-and-mountsecretb64enc)
  - [Copying Files](#copying-files)
  - [SAML Certificates (idp_cert)](#saml-certificates-idp_cert)
  - [Certificates and Keys](#certificates-and-keys)
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


## Prerequisites
- Kubernetes 1.30+
- Helm 3.0+
- Ingress controller (e.g., NGINX)

## Installation

> **Recommended:** Review the [values.yaml](values.yaml) file and use a custom values file (`-f my-values.yaml`) for your installation. While individual parameters can be passed via `--set`, using a values file provides better visibility and reproducibility.
> **Required:** `container.image.url` and `storage.class` must always be set. `namespace.name` should be set in your values file — see [Namespace Resolution](#namespace-resolution) below.

### Namespace Resolution
The chart resolves the target namespace using the following priority order:

| Priority | Source | Example |
|----------|--------|---------|
| 1 (highest) | `namespace.name` in values | `namespace.name: my-space` |
| 2 | `--namespace` flag or `HELM_NAMESPACE` env var | `helm install ... --namespace my-space` |
| 3 (fallback) | Release name | `helm install my-space ...` |

**Recommendation:** Set `namespace.name` explicitly in your values file. This ensures consistent behavior regardless of how or where the chart is installed (CI pipelines, operators, or direct `helm` commands).

### 1. Add the Helm Repository
```sh
helm repo add fabric https://helm.share.cloud.k2view.com/fabric/
helm repo update
```

### 2. Install the Chart

**Using a values file (recommended):**
```sh
# From remote repository
helm install SPACE_NAME fabric/fabric \
  --namespace SPACE_NAME \
  -f my-values.yaml \
  --create-namespace

# From local clone
helm install SPACE_NAME . \
  --namespace SPACE_NAME \
  -f my-values.yaml \
  --create-namespace
```

**Using `--set` flags (quick start):**
```sh
# From remote repository
helm install SPACE_NAME fabric/fabric \
  --namespace SPACE_NAME \
  --set container.image.url=YOUR_IMAGE_URL \
  --set storage.class=YOUR_STORAGE_CLASS \
  --create-namespace

# From local clone
helm install SPACE_NAME . \
  --namespace SPACE_NAME \
  --set container.image.url=YOUR_IMAGE_URL \
  --set storage.class=YOUR_STORAGE_CLASS \
  --create-namespace
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
| `labels` | array | `[]` | Global labels applied to all resources |
| `annotations` | array | `[]` | Global annotations applied to all resources |
| `namespace.create` | bool | `false` | Whether to create the namespace |
| `namespace.name` | string | `""` | Target namespace. When set, takes priority over `--namespace` flag. Falls back to `--namespace`, then release name. |
| `namespace.annotations` | array | `[]` | Resource-specific annotations for namespace |
| `deploy.type` | string | `Deployment` | Deployment type (`Deployment` or `StatefulSet`) |
| `serviceAccount.create` | bool | `true` | Create a new service account |
| `serviceAccount.name` | string | `""` | Name of the service account (empty for new) |
| `serviceAccount.provider` | string | `""` | Cloud provider for service account |
| `serviceAccount.arn` | string | `""` | AWS IAM role ARN |
| `serviceAccount.project_id` | string | `""` | GCP project ID |
| `serviceAccount.cluster_name` | string | `""` | Cluster name |
| `serviceAccount.azure_client_id` | string | `""` | Azure Managed Identity client ID |
| `serviceAccount.automountServiceAccountToken` | bool | not set | Set to `false` to explicitly disable automounting the service account token. When not set, Kubernetes defaults to `true` |
| `serviceAccount.annotations` | array | `[]` | Resource-specific annotations for service account |
| `container.replicas` | int | `1` | Number of Fabric pods |
| `container.annotationsList` | list | `[{name: description, value: Fabric on Kubernetes}]` | List of pod annotations |
| `container.annotations` | array | `[]` | Resource-specific annotations for deployment/statefulset |
| `container.resource_allocation.limits.memory` | string | `8Gi` | Memory limit |
| `container.resource_allocation.limits.cpu` | string | `2` | CPU limit |
| `container.resource_allocation.requests.memory` | string | `2Gi` | Memory request |
| `container.resource_allocation.requests.cpu` | string | `0.4` | CPU request |
| `container.image.url` | string | `""` | Fabric image URL |
| `container.image.repoSecret.name` | string | `registry-secret` | Image pull secret name |
| `container.image.repoSecret.enabled` | bool | `false` | Enable image pull secret |
| `container.livenessProbe.initialDelaySeconds` | int | `0` | Initial delay in seconds for the liveness probe to start. |
| `container.livenessProbe.periodSeconds` | int | `60` | Time period in seconds for the liveness probe to repeat. |
| `container.livenessProbe.timeoutSeconds` | int | `15` | Maximum time in seconds for liveness probe execution to fail due to timeout. |
| `container.livenessProbe.successThreshold` | int | `1` | How many successful attempts before setting the pod to alive. |
| `container.livenessProbe.failureThreshold` | int | `3` | How many failed attempts before setting the pod to dead. |
| `container.readinessProbe.initialDelaySeconds` | int | `0` | Initial delay in seconds for the readiness probe to start. |
| `container.readinessProbe.periodSeconds` | int | `30` or `15` | Time period in seconds for the readiness probe to repeat. Default value varies between Studio and Fabric-only. |
| `container.readinessProbe.timeoutSeconds` | int | `15` | Maximum time in seconds for readiness probe execution to fail due to timeout. |
| `container.readinessProbe.successThreshold` | int | `1` | How many successful attempts before setting the pod to healthy. |
| `container.readinessProbe.failureThreshold` | int | `3` or `1` | How many failed attempts before setting the pod to unhealthy. Default value varies between Studio and Fabric-only. |
| `container.startupProbe.initialDelaySeconds` | int | `30` | Initial delay in seconds for the startup probe to start. |
| `container.startupProbe.periodSeconds` | int | `15` | Time period in seconds for the startup probe to repeat. |
| `container.startupProbe.timeoutSeconds` | int | `5` | Maximum time in seconds for startup probe execution to fail due to timeout. |
| `container.startupProbe.successThreshold` | int | `1` | How many successful attempts before setting the pod to started. |
| `container.startupProbe.failureThreshold` | int | `20` | How many failed attempts before setting the pod to failed to start. |
| `storage.pvc.enabled` | bool | `false` | Create the shared PVC (`fabric-claim`). Always created for Deployment regardless of this value; opt-in for StatefulSet |
| `storage.emptyDir` | bool | `false` | StatefulSet only. When `true`, replaces `volumeClaimTemplates` with an ephemeral `emptyDir` volume. Data is lost on pod restart. `storage.class` is ignored |
| `storage.securityContext` | bool | `true` | Enable pod security context |
| `storage.class` | string | `managed` | Storage class name (ignored when `storage.emptyDir: true`) |
| `storage.allocated_amount` | string | `10Gi` | Storage size. Applied to the PVC for Deployment, to `volumeClaimTemplates` for StatefulSet, or to `emptyDir.sizeLimit` when `storage.emptyDir: true` |
| `storage.annotations` | array | `[]` | Resource-specific annotations for PVC |
| `service.annotations` | array | `[]` | Resource-specific annotations for service |
| `networkPolicy.annotations` | array | `[]` | Resource-specific annotations for network policy |
| `secrets.annotations` | array | `[]` | Resource-specific annotations for secrets |
| `scaling.enabled` | bool | `false` | Enable autoscaling |
| `scaling.minReplicas` | int | `1` | Minimum replicas for autoscaling |
| `scaling.maxReplicas` | int | `1` | Maximum replicas for autoscaling |
| `scaling.targetCPU` | int | `90` | Target CPU utilization for HPA |
| `scaling.annotations` | array | `[]` | Resource-specific annotations for HPA |
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
| `mountSecret.enabled` | bool | `false` | Also mount the secret on the Fabric container. The `init-fabric` container always mounts it. See [Mounted Secrets](#mounted-secrets-mountsecret-and-mountsecretb64enc) |
| `mountSecret.name` | string | `config-secrets` | Name of the secret to mount |
| `mountSecret.mountPath` | string | `/opt/apps/fabric/config-secrets` | Path to mount the secret |
| `mountSecret.data` | object | See `values.yaml` | Files to mount, as plain text: one file per key. Built-in keys: `config`, `cp_files`, `idp_cert` |
| `mountSecretB64enc.enabled` | bool | `false` | Also mount the secret on the Fabric container. The `init-fabric` container always mounts it |
| `mountSecretB64enc.name` | string | `mount-b64-secrets` | Name of the base64 secret to mount |
| `mountSecretB64enc.mountPath` | string | `/opt/apps/fabric/mount-b64-secrets` | Path to mount the base64 secret |
| `mountSecretB64enc.data` | object | See `values.yaml` | Files to mount, values already base64-encoded (for binary files) |
| `secretsList` | list | See `values.yaml` | Secrets whose keys become environment variables in both containers. See [Environment Variables](#environment-variables-secretslist-and-initsecretslist) |
| `initSecretsList` | list | See `values.yaml` | Secrets whose keys become environment variables in the `init-fabric` container only |
| `affinity.type` | string | `none` | Pod affinity/anti-affinity/none |
| `affinity.label.name` | string | `topology.kubernetes.io/zone` | Affinity label name |
| `affinity.label.value` | string | `region-a` | Affinity label value |

> **Tip:** For advanced configuration and secret formats, refer to the comments in `values.yaml`.

### Deployment Options
The Fabric Helm Chart supports two deployment types, each suited for different environments and use cases:

#### 1. Deployment (Recommended for Development/Studio)
Use this mode for development environments or when running Fabric Studio. It uses one shared PVC and works only in a single-replica setup.

**Recommended configuration:**
- `deploy.type: Deployment`
- `container.replicas: 1`

> **Note:** Fabric Studio is a single-node application and does not support multiple replicas or high availability. Setting `container.replicas` above `1` is not supported and will result in undefined behavior. For production deployments, use the StatefulSet configuration instead.

#### 2. StatefulSet (Recommended for Production/Server)
Use this mode for staging or production environments, or when running Fabric Server. This mode is designed for stateful workloads and high availability.

**Recommended configuration:**
- `deploy.type: StatefulSet`
- Set `container.replicas` to the desired number of server instances

**Storage options for StatefulSet:**

| Scenario | Configuration | Notes |
|----------|--------------|-------|
| Persistent (default) | `storage.class: <class>`, `storage.allocated_amount: <size>` | Each pod gets its own PVC via `volumeClaimTemplates` |
| Ephemeral | `storage.emptyDir: true`, `storage.allocated_amount: <size>` | Uses `emptyDir`; data lost on pod restart. `storage.class` is ignored |

> **Note:** `storage.pvc.enabled` has no effect on StatefulSet storage — it only controls whether the shared `fabric-claim` PVC (used by Deployment) is created.


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

#### Path-Based Routing
When using path-based ingress routing (e.g., `domain/space-tenant`), Fabric must be configured to ignore the first segment of the URL path so that it does not interfere with LB-level routing. Set `PATH_BASE_ROUTING` under the `[fabric]` section:

```ini
[fabric]
PATH_BASE_ROUTING=true
```

> **Note:** Without this setting, Fabric will treat the path prefix as part of the API route and requests will fail.

## Pod Initialization (init-fabric)
Every Fabric pod (Deployment and StatefulSet) starts with an init container named `init-fabric`. It runs the same image entrypoint as the Fabric container, with `START_FABRIC=false`. It prepares the workspace volume (`/opt/apps/fabric/workspace`) and exits, and then the Fabric container starts on the same workspace.

The init container:
- Merges `mountSecret.data.config` into `workspace/config/config.ini`
- Copies the files listed in `cp_files` (see [Copying Files](#copying-files-cp_files))
- Adds certificates and keys to the truststore and keystore (see [SAML Certificates](#saml-certificates-idp_cert) and [Certificates and Keys](#certificates-and-keys))
- Clones and builds the project when `GIT_REPO` is set

It runs on every pod start, so a change to the values takes effect after `helm upgrade` restarts the pods. The Studio image is an exception for some settings, see the [Studio first start](#supported-variables) note.

What each container gets:

| | `init-fabric` | `fabric` |
|---|---|---|
| Workspace volume (`/opt/apps/fabric/workspace`) | always | always |
| `mountSecret` files | always | only when `mountSecret.enabled: true` |
| `mountSecretB64enc` files | always | only when `mountSecretB64enc.enabled: true` |
| `secretsList` environment variables | always | always |
| `initSecretsList` environment variables | always | never |

### Environment Variables: secretsList and initSecretsList
Both lists create Kubernetes Secrets. Each key under `data` becomes an environment variable with the same name. Keys with an empty value are skipped.

- `secretsList`: for variables Fabric needs at runtime, such as `MAX_HEAP`. They are set in both containers.
- `initSecretsList`: for variables that are only needed to prepare the workspace, such as `CONFIG_UPDATE_FILE`, `COPY_FILES`, `IDP_CERT_PATH`, `GIT_REPO` and `GIT_TOKEN`. They are set in the init container only, so they are not visible in the running Fabric container.

When the same key is in both lists, the init container uses the value from `initSecretsList`.

```yaml
secretsList:
  - name: common-env-secrets
    data:
      MAX_HEAP: '10G'

initSecretsList:
  - name: config-init-secrets
    data:
      CONFIG_UPDATE_FILE: '/opt/apps/fabric/config-secrets/config'
      COPY_FILES: '/opt/apps/fabric/config-secrets/cp_files'
      START_FABRIC: 'false'
```

> **Note:** Keep `START_FABRIC: 'false'` in `initSecretsList`, so Fabric does not start inside the init container.

### Mounted Secrets: mountSecret and mountSecretB64enc
Both create a Kubernetes Secret and mount it as a folder: each key under `data` becomes a file `<mountPath>/<key>`. Keys with an empty value are skipped, so no file is created.

| | `mountSecret` | `mountSecretB64enc` |
|---|---|---|
| Value in `values.yaml` | Plain text, the chart encodes it | Already base64-encoded, the chart uses it as is |
| Use for | Text files: config, JSON, PEM certificates | Binary files: keystores (`.jks`, `.p12`), key files |
| Default mount path | `/opt/apps/fabric/config-secrets` | `/opt/apps/fabric/mount-b64-secrets` |

The file in the pod is always the original content, because Kubernetes decodes it when it mounts the secret. To prepare a binary value:

```sh
base64 -w0 my-keystore.p12
```

`enabled` only controls the **Fabric** container. The init container always mounts both secrets. The usual setup is to keep `enabled: false` and let the init container apply or copy the files to the workspace. The secret is then not mounted in the running Fabric container.

Mounted secret files are read-only. When Fabric needs to own or change a file, copy it to the workspace with `cp_files`.

### Copying Files
`cp_files` copies files from the mounted secrets to the workspace volume (the PVC), where they persist and Fabric can write to them. The init container runs the copy, using the file that `COPY_FILES` points to (`/opt/apps/fabric/config-secrets/cp_files` by default).

Each line is `<source> <target>`:

```yaml
mountSecret:
  data:
    cp_files: |
      /opt/apps/fabric/config-secrets/rolesPrivileges.json /opt/apps/fabric/workspace/config/rolesPrivileges.json
      /opt/apps/fabric/mount-b64-secrets/keystore.p12 /opt/apps/fabric/workspace/keystore.p12
    rolesPrivileges.json: '{"roles":{"deployer":["DEPLOY","DEPLOY_ENVIRONMENTS","SET_GLOBAL_ENVIRONMENT","DROP_LUTYPE"]},"apikeys":{"xxxxxx-xxxx-xxxx-xxxx-xxxxxx":["deployer"]}}'

mountSecretB64enc:
  data:
    keystore.p12: '<base64 of the file>'
```

Rules:
- Separate the source and target with one space. Paths cannot contain spaces.
- A folder source is copied with its content. The parent folder of the target must already exist.
- The target is overwritten on every pod start, so the secret is the source of truth.
- A source that does not exist is logged and skipped, and the pod keeps starting. Check the `init-fabric` logs when a file is missing.
- Keep `COPY_FILES` in `initSecretsList`. If it is in `secretsList`, the Fabric container also tries to copy, and fails when the secret is not mounted there.

### SAML Certificates (idp_cert)
`mountSecret.data.idp_cert` holds the identity provider (IdP) certificate in PEM format. The key only creates the file. To load it, set `IDP_CERT_PATH` in `initSecretsList`:

```yaml
mountSecret:
  data:
    idp_cert: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----

initSecretsList:
  - name: config-init-secrets
    data:
      IDP_CERT_PATH: '/opt/apps/fabric/config-secrets/idp_cert'
      IDP_ROLE: 'my-admin-role'
```

At startup the certificate is added to the Fabric truststore, and `IDP_CERT_ALIAS` in the `[saml]` section of `config.ini` is set (default alias `idp_cert`, change it with the `IDP_CERT_ALIAS` variable). The truststore is kept in the workspace (`workspace/config/.truststore`), so the certificate is still there when the Fabric container starts.

`IDP_ROLE` is the IdP role that gets Fabric admin privileges.

See [values.example_SAML](values.example_SAML) for a full SAML setup.

### Certificates and Keys
Use `ADD_CERTS_FILE` to load certificates and keys into Fabric when the pod starts:
- `addtrust`: adds a certificate to the **truststore**, the certificates Fabric trusts for outgoing TLS connections. For example, a private or self-signed CA.
- `addkey`: adds a certificate with its private key (`.p12`) to the **keystore**, the identity Fabric presents. For example, the web server TLS certificate or a client certificate.

Both stores must be on the workspace volume, so that what the init container adds also reaches the Fabric container:
- The truststore is there by default (`workspace/config/.truststore`).
- For the keystore, set `FABRIC_KEYSTORE_PATH` and `FABRIC_KEYSTORE_PASS` in `secretsList`. The default `~/.keystore` is not on the workspace volume, so keys added to it are lost.

Put the files in the mounted secrets and add a list file with one line per entry:
- `addtrust|ALIAS|PATH`
- `addkey|ALIAS|PATH|PASSWORD` (`PASSWORD` is the `.p12` password)

Then set `ADD_CERTS_FILE` in `initSecretsList` to the path of the list file:

```yaml
mountSecret:
  data:
    trusted_certs: |
      addtrust|corp_root_ca|/opt/apps/fabric/config-secrets/corp_root_ca.pem
      addkey|webserver|/opt/apps/fabric/mount-b64-secrets/webserver.p12|my-p12-password
    corp_root_ca.pem: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----

mountSecretB64enc:
  data:
    webserver.p12: '<base64 of the file>'

secretsList:
  - name: common-env-secrets
    data:
      FABRIC_KEYSTORE_PATH: '/opt/apps/fabric/workspace/config/.keystore'
      FABRIC_KEYSTORE_PASS: 'my-keystore-password'

initSecretsList:
  - name: config-init-secrets
    data:
      ADD_CERTS_FILE: '/opt/apps/fabric/config-secrets/trusted_certs'
```

Use a unique alias for each entry. Adding an entry with an existing alias replaces it.

To use your own truststore instead of the default one, copy it to the workspace with [cp_files](#copying-files-cp_files) and set `FABRIC_TRUSTSTORE_PATH` and `FABRIC_TRUSTSTORE_PASS` in `secretsList`.


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
> - Autoscaling is possible for Fabric but may not be suitable for all workloads, please evaluate based on your specific use case and load patterns.

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

Storage behavior differs between deployment types:

### Deployment (`deploy.type: Deployment`)
Always uses a shared PVC named `fabric-claim`, which the chart always creates in this mode (`storage.pvc.enabled` is ignored):

```yaml
storage:
  class: managed
  allocated_amount: 20Gi
```

### StatefulSet (`deploy.type: StatefulSet`)
By default, each pod gets its own PVC via `volumeClaimTemplates`:

```yaml
storage:
  class: managed
  allocated_amount: 20Gi
```

To use ephemeral storage instead (data lost on pod restart):

```yaml
storage:
  emptyDir: true
  allocated_amount: 20Gi  # sets emptyDir.sizeLimit; storage.class is ignored
```

> **Note:** `storage.pvc.enabled` does not affect StatefulSet pod storage — it only controls creation of the shared `fabric-claim` PVC used by the Deployment.

## Environment Variables
You can set environment variables for fabric by adding them under secretsList.data in values.yaml:

```yaml
secretsList:
  - name: common-env-secrets
    data:
      MY_ENV_VAR_1: 'VALUE_1'
      MY_ENV_VAR_2: 'VALUE_2'
```

For variables that only the init container needs, use `initSecretsList`. See [Environment Variables: secretsList and initSecretsList](#environment-variables-secretslist-and-initsecretslist).

### Supported Variables
The chart runs either the **Fabric** image (Fabric server) or the **Studio** image (Fabric with the web IDE). Both use the same values, but some variables apply to only one image.

- **List**: where to set the variable, `init` for `initSecretsList` or `common` for `secretsList`.
- **Image**: `Both`, `Fabric` or `Studio`.

| Variable | List | Image | Description |
|----------|------|-------|-------------|
| `MIN_HEAP` / `MAX_HEAP` | common | Both | JVM heap size, for example `4G` |
| `ADMIN_USER` | init | Both | First admin user, as `username/password` |
| `IDP_ROLE` | init | Both | IdP role that gets Fabric admin privileges |
| `ADD_MODULES` / `REMOVE_MODULES` | init | Both | Comma-separated Fabric modules to add or remove. `REMOVE_MODULES` matches part of a name, so use full module names. Studio: first start only |
| `ADD_CERTS_FILE` | init | Both | Path to a file that lists certificates (`addtrust`) and keys (`addkey`) to load at startup. See [Certificates and Keys](#certificates-and-keys) |
| `http_proxy` / `https_proxy` / `no_proxy` | common | Both | Proxy for Fabric (JVM) and git |
| `FABRIC_LOG_TYPE` | common | Both | `CONTAINER_STDOUT`, `STDOUT` or `NONE`: how Fabric logs reach the pod log |
| `MONITORING` | common | Both | `true` sets up the Prometheus JMX exporter |
| `GIT_REPO` / `GIT_BRANCH` / `GIT_PATH_IN_REPO` / `GIT_TOKEN` | init | Both | Fabric: clone, build and deploy the project on every start. Studio: clone the project into the workspace on first start, for development |
| `SPACE_NAME` | common | Studio | Space name, used as the node ID and as the git user name and email for commits |
| `NEO4J_AUTH` | init | Studio | Initial password of the local Neo4j, when the image includes it |

> **Studio first start:** the Studio image applies `mountSecret.data.config` (`CONFIG_UPDATE_FILE`), modules and the git clone only when the workspace has no project yet. To apply changes to these settings on an existing workspace, set `INIT_CONF: 'true'` in `initSecretsList` for one restart. The git clone is still skipped when the project exists.

## Troubleshooting
- Check pod logs: `kubectl logs <pod-name> -n <namespace>`
- Check the init container logs when the pod is stuck in `Init` or Fabric starts with wrong settings: `kubectl logs <pod-name> -c init-fabric -n <namespace>`
- The startup log of both containers is also written to `/opt/apps/fabric/workspace/logs/k2init.out`
- Describe resources: `kubectl describe pod <pod-name> -n <namespace>`
- Verify ingress and service endpoints.

## Support
For issues, questions, or feature requests, please contact your Fabric support representative, email us at [support@k2view.com](mailto:support@k2view.com), or open an issue in the official repository.
