# fabric

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Fabric Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespace.create | bool | `true` | true - create the namespace, false - use existing namespace |
| namespace.name | string | `"space-tenant"` | The name of the namespace |
| labels | list |  | List of lables for fabric pods, list of name and value |
| deploy.type | string | `"Deployment"` | The kind of fabric, can be Deployment or StatefulSet |
| container.replicas | int | `1` | Number of replicas of fabric pods |
| container.annotationsList | list |  | List of annotations for fabric pods, list of name and value |
| container.resource_allocation.requests.cpu | string | `"0.4"` | CPU request for Fabric pod |
| container.resource_allocation.requests.memory | string | `"2Gi"` | Memory request for Fabric pod |
| container.resource_allocation.limits.cpu | string | `"1"` | CPU limit for Fabric pod |
| container.resource_allocation.limits.memory | string | `"4Gi"` | Memory limit for Fabric pod |
| container.livenessProbe.initialDelaySeconds | int | `120` | Seconds to wait to start liveness probe |
| container.livenessProbe.periodSeconds | int | `60` | Seconds to wait to period liveness probe |
| container.image.url | string | `""` | Fabric image url |
| container.image.repoSecret.enabled | bool | `false` | Change to true if need secreet to pull the image |
| container.image.repoSecret.dockerRegistry | dictionary |  | All under this section will be converted to json and deployed as a kubernetes.io/dockerconfigjson secret |
| listening_port | int | `3213` | Fabric port |
| storage.pvc.enabled | bool | `true` | Create PVC for fabric pod (used for single node) |
| storage.class | string | `"gp2"` | PVC storage type |
| storage.alocated_amount | string | `"10Gi"` | Amount of storage for PVC |
| scaling.enabled | bool | `false` | Create HPA for fabric Deployment/StatefulSet |
| scaling.minReplicas | int | `1` | The minimum replica for HPA |
| scaling.maxReplicas | int | `1` | The maximum replica for HPA |
| scaling.targetCPU | int | `90` | Target average CPU for fabric cluster |
| ingress.enabled | bool | `true` | Create ingress for Fabric |
| ingress.port | int | `3213` | Fabric port |
| ingress.host | string | `"space-tenant.domain"` | Domain of Fabric space |
| ingress.tlsSecret.enabled | bool | `false` | Create TLS secret for ingress |
| ingress.tlsSecret.crt | string | `""` | TLS certificate for domain |
| ingress.tlsSecret.key | string | `""` | Key for TLS certificate for domain |
| ingress.annotations | list |  | List of annotations for fabric ingress, list of name and value  |
| mountSecret.name | string | `"config-secrets"` | Name of secret to mount |
| mountSecret.enabled | bool | `false` | Mount the secret as files to Fabric pod, if false will mount the secret only on init container |
| mountSecret.mountPath | string | `"/opt/apps/fabric/config-secrets"` | Path to mount the secret on the container |
| mountSecret.data | dictionary |  | List of secrets to mount as a files, list of name: value, the name will be the mane of the file, the value will be a string content of the file  |
| secretsList | list |  | List of secrets for fabric container and init container, list of name and data, the name will be the name of the secret and the data will contain key: value dictionary, the key and value will be added as a environment  variables on the container |
| initSecretsList | list |  | List of secrets for fabric init container, list of name and data, the name will be the name of the secret and the data will contain key: value dictionary, the key and value will be added as a environment  variables on the container |


### Deploy type
For single node that can be "paused" prefered to use Deployment (mainly for Studio spaces).
For multi node it prefered to use StatefulSet, in this case eace pod will have private PVC, in this case change deploy.type to StatefulSet and storage.pvc.enabled to false.

> NOTE: Pause space will change the replica of all deployments to 0 to release resources when the space not used.


### Configure Fabric
To change any config in Fabric config.ini you can add it as a string to mountSecret.data.config and point to it with environment variable CONFIG_UPDATE_FILE.
The convention of config string is: 'section|key|value\n'


## For more information, read below:
<ul>
   <li><a href="https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/">Horizontal pod autoscale</a></li>
</ul>
