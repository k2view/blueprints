# fabric

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| container.annotationsList[0].name | string | `"description"` |  |
| container.annotationsList[0].value | string | `"Fabric on Kubernetes"` |  |
| container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".password | string | `""` |  |
| container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".username | string | `""` |  |
| container.image.repoSecret.enabled | bool | `false` |  |
| container.image.repoSecret.name | string | `"registry-secret"` |  |
| container.image.url | string | `""` |  |
| container.livenessProbe.initialDelaySeconds | int | `120` |  |
| container.livenessProbe.periodSeconds | int | `60` |  |
| container.replicas | int | `1` |  |
| container.resource_allocation.limits.cpu | string | `"1"` |  |
| container.resource_allocation.limits.memory | string | `"4Gi"` |  |
| container.resource_allocation.requests.cpu | string | `"0.4"` |  |
| container.resource_allocation.requests.memory | string | `"2Gi"` |  |
| deploy.type | string | `"Deployment"` |  |
| ingress.annotations[0].key | string | `"kubernetes.io/ingress.class"` |  |
| ingress.annotations[0].value | string | `"nginx"` |  |
| ingress.annotations[1].key | string | `"nginx.ingress.kubernetes.io/proxy-body-size"` |  |
| ingress.annotations[1].value | string | `"0"` |  |
| ingress.annotations[2].key | string | `"nginx.ingress.kubernetes.io/proxy-read-timeout"` |  |
| ingress.annotations[2].value | string | `"7d"` |  |
| ingress.annotations[3].key | string | `"nginx.ingress.kubernetes.io/ssl-redirect"` |  |
| ingress.annotations[3].value | string | `"false"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | string | `"space-tenant.domain"` |  |
| ingress.port | int | `3213` |  |
| ingress.tlsSecret.crt | string | `""` |  |
| ingress.tlsSecret.enabled | bool | `false` |  |
| ingress.tlsSecret.key | string | `""` |  |
| initSecretsList[0].data.GIT_BRANCH | string | `""` |  |
| initSecretsList[0].data.GIT_PATH_IN_REPO | string | `""` |  |
| initSecretsList[0].data.GIT_REPO | string | `""` |  |
| initSecretsList[0].data.GIT_TOKEN | string | `""` |  |
| initSecretsList[0].data.IDP_CERT_PATH | string | `""` |  |
| initSecretsList[0].data.IDP_ROLE | string | `""` |  |
| initSecretsList[0].data.START_FABRIC | string | `"false"` |  |
| initSecretsList[0].name | string | `"config-init-secrets"` |  |
| labels[0].name | string | `"tenant"` |  |
| labels[0].value | string | `"my-tenant"` |  |
| labels[1].name | string | `"space"` |  |
| labels[1].value | string | `"my-space"` |  |
| listening_port | int | `3213` |  |
| mountSecret.data.config | string | `"fabricdb|MDB_DEFAULT_SCHEMA_CACHE_STORAGE_TYPE|NFS\\nfabricdb|MDB_DEFAULT_CACHE_PATH|/opt/apps/fabric/pod_tmp/fdb_cache\\ndefault_pubsub|TYPE|MEMORY\\ncommon_area_pubsub|TYPE|MEMORY\\nfabric|WEB_SESSION_EXPIRATION_TIME_OUT|540\\nfabric|ENABLE_BROADWAY_DEBUG_SERVLET|true\\ndefault_session|RECONNECT_MAX_DELAY_MS|1000\\nfabric|ENABLE_DB_INTERFACE_PROXY|true\\nfabric|WEBSERVER_FILTERS|[{\\\"class\\\":\\\"com.k2view.cdbms.ws.ProxyForward\\\",\\\"patterns\\\":[\\\"/studio/*\\\"],\\\"params\\\":{\\\"target\\\":\\\"http://localhost:3000\\\",\\\"isStaticTarget\\\":true}},{\\\"class\\\":\\\"com.k2view.cdbms.ws.ProxyForward\\\",\\\"patterns\\\":[\\\"/socket.io/*\\\"],\\\"params\\\":{\\\"target\\\":\\\"http://localhost:3000\\\",\\\"isStaticTarget\\\":false}}];\\nfabric|OVERRIDE_API_SCHEMA|HTTPS|ADD\\nfabric|OVERRIDE_API_PORT|443|ADD\\ndata_discovery|GRAPH_DB_URL|neo4j://dev-neo4j-service:7687\\ndata_discovery|GRAPH_DB_USER|neo4j\\ndata_discovery|GRAPH_DB_PASSWORD|Q1w2e3r4t5\\n"` |  |
| mountSecret.data.cp_files | string | `""` |  |
| mountSecret.data.idp_cert | string | `""` |  |
| mountSecret.enabled | bool | `false` |  |
| mountSecret.mountPath | string | `"/opt/apps/fabric/config-secrets"` |  |
| mountSecret.name | string | `"config-secrets"` |  |
| namespace.create | bool | `true` |  |
| namespace.name | string | `"space-tenant"` |  |
| networkPolicy.enabled | bool | `true` |  |
| scaling.enabled | bool | `false` |  |
| scaling.maxReplicas | int | `1` |  |
| scaling.minReplicas | int | `1` |  |
| scaling.targetCPU | int | `90` |  |
| secretsList[0].data.config | string | `""` |  |
| secretsList[0].data.cp_files | string | `""` |  |
| secretsList[0].data.idp_cert | string | `""` |  |
| secretsList[0].data.local_key | string | `""` |  |
| secretsList[0].name | string | `"config-secrets"` |  |
| secretsList[1].data.CONFIG_UPDATE_FILE | string | `"/opt/apps/fabric/config-secret/config"` |  |
| secretsList[1].data.COPY_FILES | string | `""` |  |
| secretsList[1].data.INIT_CONF | string | `""` |  |
| secretsList[1].data.PROJECT_ID | string | `""` |  |
| secretsList[1].data.PROJECT_NAME | string | `""` |  |
| secretsList[1].data.SPACE_NAME | string | `""` |  |
| secretsList[1].name | string | `"common-env-secrets"` |  |
| secretsList[2].data."cassandra.default.hosts" | string | `"cassandra-service"` |  |
| secretsList[2].data."cassandra.default.password" | string | `"cassandra"` |  |
| secretsList[2].data."cassandra.default.user" | string | `"cassandra"` |  |
| secretsList[2].name | string | `"cassandra-secrets"` |  |
| storage.alocated_amount | string | `"10Gi"` |  |
| storage.class | string | `"gp2"` |  |
| storage.pvc.enabled | bool | `true` |  |
| storage.securityContext | bool | `true` |  |
| serviceAccount.create | bool | `true` | For new sa, creation os sa only in k8s side. |
| serviceAccount.name | string | `""`   | For existing sa, if create is true, name should be an empty string |
| serviceAccount.provider | string | `""` | aws or gcp. |
| serviceAccount.arn | string | `""` | For aws only, iam role arn. |
| serviceAccount.gcp_service_account_name | string |`""`| For gcp only, service account name. |
| serviceAccount.project_id | string |`""`| For gcp only, project id. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
