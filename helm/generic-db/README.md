# generic-db
![Version: 1.1.9](https://img.shields.io/badge/Version-1.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Example Helm chart that deploys a generic database, such as PostgreSQL, Cassandra, or Neo4j, on Kubernetes.

## Description
The `generic-db` Helm chart is a reference example of a unified and configurable approach to deploying database systems, including PostgreSQL, Cassandra, Kafka, and Neo4j, on Kubernetes. It uses a single chart with parameterized values to control behavior per database type (`app_name`), including image selection, ports, volumes, and secrets.

## Values
### Global Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `app_name` | string | `"generic-db"` | Name of the database type to deploy (`postgres`, `cassandra`, `kafka`, `neo4j`) |
| `namespace.name` | string | `""` | Name of the Kubernetes namespace (defaults to release name) |
| `annotations` | array | `[]` | Global annotations applied to all resources |
| `labels` | array | `[]` | Global labels applied to all resources |
| `serviceAccount.automountServiceAccountToken` | bool | `""` | Set to `false` to explicitly disable automounting the service account token. When not set, Kubernetes defaults to `true` |

### Container Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `container.replicas` | int | `1` | Number of container replicas |
| `container.resource_allocation.limits.cpu` | string | `"1"` | CPU limit for the container |
| `container.resource_allocation.limits.memory` | string | `"4Gi"` | Memory limit for the container |
| `container.resource_allocation.requests.cpu` | string | `"0.4"` | CPU request for the container |
| `container.resource_allocation.requests.memory` | string | `"1Gi"` | Memory request for the container |
| `container.storage_path` | string | `"/opt/apps/pgsql/data/data/"` | Path to the storage directory in the container |
| `container.annotations` | array | `[]` | Resource-specific annotations for deployment |
| `container.labels` | array | `[]` | Resource-specific labels for deployment |

### Secrets Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `create_secrets` | bool | `true` | Whether to create default secrets |
| `secrets` | array | `[]` | List of custom secrets to create |

### Storage Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `storage.class` | string | `"managed"` | Storage class name |
| `storage.allocated_amount` | string | `"10Gi"` | Allocated storage size |
| `storage.securityContext` | bool | `true` | Enable security context |
| `storage.annotations` | array | `[]` | Resource-specific annotations for PVC |
| `storage.labels` | array | `[]` | Resource-specific labels for PVC |

### Network Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `service.port` | int | Database-specific | Service port (auto-configured based on database type) |
| `service.annotations` | array | `[]` | Resource-specific annotations for service |
| `service.labels` | array | `[]` | Resource-specific labels for service |
| `networkPolicy.enabled` | bool | `true` | Enable network policy |
| `networkPolicy.annotations` | array | `[]` | Resource-specific annotations for network policy |
| `networkPolicy.labels` | array | `[]` | Resource-specific labels for network policy |

### Affinity Configuration
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `affinity.type` | string | `"none"` | Affinity type (`none`, `affinity`, `anti-affinity`) |
| `affinity.label.name` | string | `"topology.kubernetes.io/zone"` | Affinity label name |
| `affinity.label.value` | string | `"region-a"` | Affinity label value |

### Default Database Configurations
The chart automatically configures certain values based on the selected database type (`app_name`):

#### PostgreSQL (app_name: postgres)
```yaml
storage_path: "/opt/apps/pgsql/data/data/"
service_port: 5432
secrets:
  - PGDATA: "/opt/apps/pgsql/data/data/pgdata"
  - POSTGRES_PASSWORD: "postgres"
  - POSTGRES_USERNAME: "postgres"
```

#### Cassandra (app_name: cassandra)
```yaml
storage_path: "/var/lib/cassandra"
service_port: 9042
secrets:
  - HEAP_NEWSIZE: "128M"
  - MAX_HEAP_SIZE: "2G"
  - CASSANDRA_DC: "DC1"
  - CASSANDRA_ENDPOINT_SNITCH: "GossipingPropertyFileSnitch"
```

#### Kafka (app_name: kafka)
```yaml
storage_path: "/home/kafka/zk_data"
service_port: 9093
secrets:
  - DATA: "/home/kafka/zk_data"
```

#### Neo4j (app_name: neo4j)
```yaml
storage_path: "/var/lib/neo4j/data"
service_port: 7687
secrets:
  - NEO4J_PLUGINS: '["graph-data-science", "apoc"]'
  - NEO4J_server_config_strict__validation_enabled: "false"
  - NEO4J_AUTH: "neo4j/changeit"
  - NEO4J_ACCEPT_LICENSE_AGREEMENT: "yes"
```

## Installation
To install the chart with the release name `my-release`:
```bash
helm install my-release ./generic-db
```

To deploy a specific database type, set the `app_name` value:
```bash
helm install my-release ./generic-db --set app_name=postgres
```

For custom configurations, provide your own values file:
```bash
helm install my-release ./generic-db -f my-values.yaml
```


## Values Examples
The `generic-db` Helm chart can be customized to deploy different databases by adjusting the values in the provided examples. Each database has a corresponding values file:
- **Cassandra**: `values.example_cassandra`
- **Kafka**: `values.example_kafka`
- **Neo4j**: `values.example_neo4j`
- **Postgres**: `values.yaml` (default configuration)

These high-level configurations demonstrate how to customize the generic-db Helm chart to suit various database systems by modifying key parameters in the values files.

### Cassandra
To deploy **Cassandra**, use `values.example_cassandra`. This configuration sets `app_name` to `cassandra`, specifies the Cassandra Docker image, adjusts resource allocations suitable for a Cassandra deployment, and includes necessary secrets for authentication.

### Kafka
For **Kafka**, apply `values.example_kafka`. This file sets `app_name` to `kafka`, points to a Kafka Docker image, configures the appropriate number of replicas, and includes required secrets and resource settings.

### Neo4j
Deploy **Neo4j** by using `values.example_neo4j`. This setup changes `app_name` to `neo4j`, selects the Neo4j Docker image, adjusts resource allocations, and sets up secrets for database authentication.

### Postgres
The default `values.yaml` is configured for **PostgreSQL** deployment. It sets `app_name` to `postgres`, uses the PostgreSQL Docker image, and includes default resource allocations and secrets.
