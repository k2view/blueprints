# generic-db

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

This Helm chart deploys generic db like postgres on Kubernetes.

## Description
The generic-db Helm chart is designed to deploy a database like PostgreSQL on Kubernetes clusters. It supports configuring resource requests and limits, storage options, affinity rules, and secrets management, making it flexible for different environments and use cases.

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `affinity.label.name` | string | `"topology.kubernetes.io/zone"` | Label used for affinity scheduling |
| `affinity.label.value` | string | `"region-a"` | Value of the affinity label |
| `affinity.type` | string | `"none"` | Type of affinity (`none`, `preferred`, `required`) |
| `app_name` | string | `"postgres"` | Name of the application (e.g., `postgres`) |
| `container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".password` | string | `""` | Password for Docker registry authentication |
| `container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".username` | string | `""` | Username for Docker registry authentication |
| `container.image.repoSecret.enabled` | bool | `false` | Enable or disable the use of a Docker registry secret |
| `container.image.repoSecret.name` | string | `"registry-secret"` | Name of the Docker registry secret |
| `container.image.url` | string | `"postgres:15.7"` | Image URL for the database container |
| `container.replicas` | int | `1` | Number of container replicas |
| `container.resource_allocation.limits.cpu` | string | `"1"` | CPU limit for the container |
| `container.resource_allocation.limits.memory` | string | `"4Gi"` | Memory limit for the container |
| `container.resource_allocation.requests.cpu` | string | `"0.4"` | CPU request for the container |
| `container.resource_allocation.requests.memory` | string | `"1Gi"` | Memory request for the container |
| `container.storage_path` | string | `"/opt/apps/pgsql/data/data/"` | Path to the storage directory in the container |
| `labels[0].name` | string | `"tenant"` | Name of the first label |
| `labels[0].value` | string | `"my-tenant"` | Value of the first label |
| `labels[1].name` | string | `"space"` | Name of the second label |
| `labels[1].value` | string | `"my-space"` | Value of the second label |
| `namespace.name` | string | `"space-tenant"` | Name of the Kubernetes namespace |
| `networkPolicy.enabled` | bool | `true` | Enable or disable the network policy |
| `secrets[0].key` | string | `"POSTGRES_USERNAME"` | Key for the PostgreSQL username secret |
| `secrets[0].value` | string | `"postgres"` | Value for the PostgreSQL username secret |
| `secrets[1].key` | string | `"POSTGRES_PASSWORD"` | Key for the PostgreSQL password secret |
| `secrets[1].value` | string | `"postgres"` | Value for the PostgreSQL password secret |
| `service.port` | int | `5432` | Port for the PostgreSQL service |
| `storage.alocated_amount` | string | `"10Gi"` | Amount of storage allocated for the database |
| `storage.class` | string | `"regional-pd"` | Storage class for the persistent volume |


## Installation
To install the chart with the release name my-release:

```bash
helm install my-release ./generic-db
```

To customize the deployment, you can override the default values by providing your own values.yaml file:
```bash
helm install my-release ./generic-db -f my-values.yaml
```
