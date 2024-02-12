# Fabric Helm Chart for Kubernetes

![Version: 1.1.6](https://img.shields.io/badge/Version-1.1.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7.2](https://img.shields.io/badge/AppVersion-7.2-informational?style=flat-square)

Fabric Helm Chart for Kubernetes

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespace.create | bool | `true` | Flag to create a new Kubernetes namespace for the deployment. |
| namespace.name | string | `"space-tenant"` | The name of the Kubernetes namespace to be used or created. |
| container.annotationsList | list |`[]`| A list of annotations to be added to the container. Each annotation is defined by a name-value pair. |
| container.image.url | string | `""` | URL of the container image to be used. |
| container.image.repoSecret.enabled | bool | `false` | Flag to enable or disable the use of a Docker registry secret. |
| container.image.repoSecret.dockerRegistry | object |`{}`| Configuration for the Docker registry secret. Includes authentication details like username and password. |
| container.image.repoSecret.name | string | `"registry-secret"` | The name of the Docker registry secret. |
| container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".password | string | `""` | The password for Docker registry authentication. |
| container.image.repoSecret.dockerRegistry.auths."docker.share.cloud.k2view.com".username | string | `""` | The username for Docker registry authentication. |
| container.livenessProbe.initialDelaySeconds | int | `120` | Initial delay in seconds for the liveness probe to start. |
| container.livenessProbe.periodSeconds | int | `60` | Time period in seconds for the liveness probe to repeat. |
| container.replicas | int | `1` | Number of container replicas to deploy. |
| container.resource_allocation.limits.cpu | string | `"1"` | The maximum amount of CPU allocated for the container. |
| container.resource_allocation.limits.memory | string | `"4Gi"` | The maximum amount of memory allocated for the container. |
| container.resource_allocation.requests.cpu | string | `"0.4"` | The requested amount of CPU for the container. |
| container.resource_allocation.requests.memory | string | `"2Gi"` | The requested amount of memory for the container. |
| deploy.type | string | `"Deployment"` | The type of deployment, Deployment for single node fabric, StatefulSet for Fabric server cluster. |
| ingress.annotations | list |`[]`| A list of annotations to be added to the ingress resource. Each annotation is defined by a key-value pair. |
| ingress.annotations[0].key | string | `"kubernetes.io/ingress.class"` | Key for the first ingress annotation, typically defining the ingress class. |
| ingress.annotations[0].value | string | `"nginx"` | Value for the first ingress annotation, specifying the ingress class. |
| ingress.enabled | bool | `true` | Flag to enable or disable ingress. |
| ingress.host | string | `"space-tenant.domain"` | Hostname for the ingress resource. |
| ingress.port | int | `3213` | Port number for the ingress resource. |
| ingress.tlsSecret.crt | string | `""` | TLS certificate for the ingress, if enabled. |
| ingress.tlsSecret.enabled | bool | `false` | Flag to enable or disable TLS for the ingress. |
| ingress.tlsSecret.key | string | `""` | TLS private key for the ingress, if TLS is enabled. |
| initSecretsList | list |`[]`| A list of initial secrets to be used by the init cantainer. |
| initSecretsList[0].data.GIT_BRANCH | string | `""` | Git branch to be used in the initial secrets. |
| initSecretsList[0].data.GIT_PATH_IN_REPO | string | `""` | Path within the Git repository for the initial secrets. |
| initSecretsList[0].data.GIT_REPO | string | `""` | Git repository URL for the initial secrets. |
| initSecretsList[0].data.GIT_TOKEN | string | `""` | Authentication token for accessing the Git repository. |
| initSecretsList[0].data.IDP_CERT_PATH | string | `""` | Path to the IDP certification in initial secrets. |
| initSecretsList[0].data.IDP_ROLE | string | `""` | IDP role to be used in the initial secrets. |
| initSecretsList[0].data.START_FABRIC | string | `"false"` | Flag to start Fabric application upon initialization. |
| initSecretsList[0].name | string | `"config-init-secrets"` | Name of the initial secrets configuration. |
| labels | list |`[]`| A list of labels to be applied to the deployment. Each label is defined by a name-value pair. |
| labels[0].name | string | `"tenant"` | The name of the first label, typically used for tenant identification. |
| labels[0].value | string | `"my-tenant"` | The value of the first label, identifying the tenant. |
| labels[1].name | string | `"space"` | The name of the second label, often used for space or environment identification. |
| labels[1].value | string | `"my-space"` | The value of the second label, identifying the space or environment. |
| listening_port | int | `3213` | Port number on which the application will listen. |
| mountSecret | object |`{}`| Configuration for mounting secrets into the container. Includes the mount path and secret data details. |
| mountSecret.name | string | `"config-secrets"` | Name of the secret to be mounted. |
| mountSecret.enabled | bool | `false` | Flag to enable or disable mounting of the secret. |
| mountSecret.mountPath | string | `"/opt/apps/fabric/config-secrets"` | Path where the secret data will be mounted. |
| mountSecret.data.config | string | `""` | Configuration data to be mounted as a secret. |
| mountSecret.data.cp_files | string | `""` | Data for copy files to be mounted as a secret. |
| mountSecret.data.idp_cert | string | `""` | IDP certificate data to be mounted as a secret. |
| networkPolicy.enabled | bool | `false` | Flag to enable or disable network policies. |
| scaling.enabled | bool | `false` | Flag to enable or disable auto-scaling. |
| scaling.maxReplicas | int | `1` | Maximum number of replicas for auto-scaling. |
| scaling.minReplicas | int | `1` | Minimum number of replicas for auto-scaling. |
| scaling.targetCPU | int | `90` | CPU utilization percentage to trigger scaling. |
| secretsList | list |`[]`| A list of secrets to be mounted on a container as a files. |
| secretsList[0].name | string | `"config-secrets"` | Name of the secrets. |
| secretsList[0].data.config | string | `""` | path to file in where each line format "[section]|[key]|[value]|<{ADD|}>" to update config.ini, can overide conf that changed based on other env var. |
| secretsList[0].data.cp_files | string | `""` | copy list of files, The referance file should be '[source] [target]' lines. |
| secretsList[0].data.idp_cert | string | `""` | IDP certificate path. |
| secretsList[0].data.local_key | string | `""` | Local key data. |
| secretsList[1].name | string | `"common-env-secrets"` | Name of the secrets. |
| secretsList[1].data.CONFIG_UPDATE_FILE | string | `"/opt/apps/fabric/config-secret/config"` | Path to the configuration update file. |
| secretsList[1].data.COPY_FILES | string | `""` | Path for cp_files file. |
| secretsList[1].data.PROJECT_NAME | string | `""` | The name of the Fabric project. |
| secretsList[1].data.SPACE_NAME | string | `""` | The name of the namespace. |
| secretsList[2].name | string | `"cassandra-secrets"` | Name of the secrets. |
| secretsList[2].data."cassandra.default.hosts" | string | `"cassandra-service"` | Default Cassandra hosts. |
| secretsList[2].data."cassandra.default.password" | string | `"cassandra"` | Default Cassandra password. |
| secretsList[2].data."cassandra.default.user" | string | `"cassandra"` | Default Cassandra user. |
| storage.alocated_amount | string | `"10Gi"` | Allocated storage amount for the persistent volume. |
| storage.class | string | `"gp2"` | Storage class to be used for persistent storage. |
| storage.pvc.enabled | bool | `true` | Flag to enable or disable the use of Persistent Volume Claims, true for Deployment, false for StatefulSet. |
| storage.securityContext | bool | `true` | Flag to enable or disable the security context for storage. |
| serviceAccount.create | bool | `true` | Flag to create a new service account in Kubernetes. |
| serviceAccount.name | string | `""`   | Name of the service account, left empty for new account creation. |
| serviceAccount.provider | string | `""` | Cloud provider for the service account (aws or gcp). |
| serviceAccount.arn | string | `""` | IAM role ARN for AWS service accounts. |
| serviceAccount.gcp_service_account_name | string |`""`| Service account name for GCP. |
| serviceAccount.project_id | string |`""`| Project ID for GCP service accounts. |
