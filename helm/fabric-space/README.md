# Fabric-space

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.5](https://img.shields.io/badge/AppVersion-1.1.5-informational?style=flat-square)

The following Helm Chart Deploys Fabric and Cassandra

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://./charts/cassandra | cassandra | ~0.1.0-0 |
| file://./charts/fabric | fabric | ~0.1.0-0 |

## Values
### Cassandra
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cassandra.container.envList[0].key | string | `"HEAP_NEWSIZE"` |  |
| cassandra.container.envList[0].value | string | `"128M"` |  |
| cassandra.container.envList[1].key | string | `"MAX_HEAP_SIZE"` |  |
| cassandra.container.envList[1].value | string | `"2G"` |  |
| cassandra.container.envList[2].key | string | `"CASSANDRA_DC"` |  |
| cassandra.container.envList[2].value | string | `"DC1"` |  |
| cassandra.container.envList[3].key | string | `"CASSANDRA_ENDPOINT_SNITCH"` |  |
| cassandra.container.envList[3].value | string | `"GossipingPropertyFileSnitch"` |  |
| cassandra.container.image.repoSecret.enabled | bool | `false` |  |
| cassandra.container.image.repoSecret.name | string | `"registry-secret"` |  |
| cassandra.container.image.url | string | `"cassandra:3.11.8"` |  |
| cassandra.container.replicas | int | `1` |  |
| cassandra.container.resource_allocation.limits.cpu | string | `"1"` |  |
| cassandra.container.resource_allocation.limits.memory | string | `"4Gi"` |  |
| cassandra.container.resource_allocation.requests.cpu | string | `"0.4"` |  |
| cassandra.container.resource_allocation.requests.memory | string | `"2Gi"` |  |
| cassandra.credentials.cassandra_password | string | `"cassandra"` |  |
| cassandra.credentials.cassandra_username | string | `"cassandra"` |  |
| cassandra.enabled | bool | `true` |  |
| cassandra.labels[0].name | string | `"tenant"` |  |
| cassandra.labels[0].value | string | `"my-tenant"` |  |
| cassandra.labels[1].name | string | `"space"` |  |
| cassandra.labels[1].value | string | `"my-space"` |  |
| cassandra.listening_port | int | `9042` |  |
| cassandra.namespace.create | bool | `true` |  |
| cassandra.namespace.name | string | `"space-tenant"` |  |
| cassandra.networkPolicy.enabled | bool | `false` |  |
| cassandra.storage.alocated_amount | string | `"10Gi"` |  |
| cassandra.storage.class | string | `"efs-cassandra"` |  |

### Fabric
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fabric.container.image.repoSecret.enabled | bool | `false` |  |
| fabric.container.image.url | string | `""` |  |
| fabric.container.livenessProbe.initialDelaySeconds | int | `300` |  |
| fabric.container.livenessProbe.periodSeconds | int | `60` |  |
| fabric.container.replicas | int | `1` |  |
| fabric.container.resource_allocation.limits.cpu | string | `"1"` |  |
| fabric.container.resource_allocation.limits.memory | string | `"4Gi"` |  |
| fabric.container.resource_allocation.requests.cpu | string | `"0.4"` |  |
| fabric.container.resource_allocation.requests.memory | string | `"2Gi"` |  |
| fabric.deploy.type | string | `"Deployment"` |  |
| fabric.enabled | bool | `true` |  |
| fabric.ingress.annotations[0].key | string | `"kubernetes.io/ingress.class"` |  |
| fabric.ingress.annotations[0].value | string | `"nginx"` |  |
| fabric.ingress.annotations[1].key | string | `"nginx.ingress.kubernetes.io/proxy-body-size"` |  |
| fabric.ingress.annotations[1].value | string | `"0"` |  |
| fabric.ingress.annotations[2].key | string | `"nginx.ingress.kubernetes.io/proxy-read-timeout"` |  |
| fabric.ingress.annotations[2].value | string | `"7d"` |  |
| fabric.ingress.annotations[3].key | string | `"nginx.ingress.kubernetes.io/ssl-redirect"` |  |
| fabric.ingress.annotations[3].value | string | `"false"` |  |
| fabric.ingress.host | string | `"space-tenant.eu-central-2-aws.cloud-dev.k2view.com"` |  |
| fabric.ingress.port | int | `3213` |  |
| fabric.ingress.tlsSecret.enabled | bool | `false` |  |
| fabric.initSecretsList[0].data.GIT_BRANCH | string | `"main"` |  |
| fabric.initSecretsList[0].data.GIT_PATH_IN_REPO | string | `""` |  |
| fabric.initSecretsList[0].data.GIT_REPO | string | `""` |  |
| fabric.initSecretsList[0].data.GIT_TOKEN | string | `""` |  |
| fabric.initSecretsList[0].data.IDP_CERT_PATH | string | `""` |  |
| fabric.initSecretsList[0].data.IDP_ROLE | string | `""` |  |
| fabric.initSecretsList[0].data.START_FABRIC | string | `"false"` |  |
| fabric.initSecretsList[0].name | string | `"config-init-secrets"` |  |
| fabric.labels[0].name | string | `"tenant"` |  |
| fabric.labels[0].value | string | `"my-tenant"` |  |
| fabric.labels[1].name | string | `"space"` |  |
| fabric.labels[1].value | string | `"my-space"` |  |
| fabric.mountSecret.data.config | string | `"section|key|value"` |  |
| fabric.mountSecret.data.cp_files | string | `""` |  |
| fabric.mountSecret.data.idp_cert | string | `""` |  |
| fabric.mountSecret.enabled | bool | `false` |  |
| fabric.mountSecret.mountPath | string | `"/opt/apps/fabric/config-secrets"` |  |
| fabric.mountSecret.name | string | `"config-secrets"` |  |
| fabric.namespace.create | bool | `false` |  |
| fabric.namespace.name | string | `"space-tenant"` |  |
| fabric.networkPolicy.enabled | bool | `false` |  |
| fabric.scaling.enabled | bool | `false` |  |
| fabric.secretsList[0].data.CONFIG_UPDATE_FILE | string | `"/opt/apps/fabric/config-secret/config"` |  |
| fabric.secretsList[0].data.COPY_FILES | string | `""` |  |
| fabric.secretsList[0].data.IDP_CERT_PATH | string | `""` |  |
| fabric.secretsList[0].data.IDP_ROLE | string | `""` |  |
| fabric.secretsList[0].data.INIT_CONF | string | `""` |  |
| fabric.secretsList[0].data.PROJECT_ID | string | `""` |  |
| fabric.secretsList[0].data.PROJECT_NAME | string | `""` |  |
| fabric.secretsList[0].data.SPACE_NAME | string | `""` |  |
| fabric.secretsList[0].name | string | `"common-env-secrets"` |  |
| fabric.secretsList[1].data."cassandra.default.hosts" | string | `"cassandra-service"` |  |
| fabric.secretsList[1].data."cassandra.default.password" | string | `"cassandra"` |  |
| fabric.secretsList[1].data."cassandra.default.user" | string | `"cassandra"` |  |
| fabric.secretsList[1].name | string | `"cassandra-secrets"` |  |
| fabric.storage.alocated_amount | string | `"10Gi"` |  |
| fabric.storage.class | string | `"efs-sc"` |  |
| fabric.storage.pvc.enabled | bool | `true` |  |
| fabric.storage.securityContext | bool | `true` |  |
| fabric.serviceAccount.create | bool | `true` | For new sa, creation os sa only in k8s side. |
| fabric.serviceAccount.name | string | `""`   | For existing sa, if create is true, name should be an empty string |
| fabric.serviceAccount.provider | string | `""` | aws or gcp. |
| fabric.serviceAccount.arn | string | `""` | For aws only, iam role arn. |
| fabric.serviceAccount.gcp_service_account_name | string |`""`| For gcp only, service account name. |
| fabric.serviceAccount.project_id | string |`""`| For gcp only, project id. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
