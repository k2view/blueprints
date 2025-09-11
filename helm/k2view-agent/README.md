# k2view-agent

![Version: 1.1.9](https://img.shields.io/badge/Version-1.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5](https://img.shields.io/badge/AppVersion-2.5-informational?style=flat-square)

This Helm chart simplifies the deployment of the K2view cloud manager site agent, ensuring a streamlined integration with your cloud infrastructure.

## Prerequisites
Before installing the K2view agent, ensure you have the following:

* **Helm 3.x** - [Install Helm](https://helm.sh/docs/intro/install/)
* **Kubernetes cluster** - Access to a running Kubernetes cluster (v1.19+)
* **MAILBOX ID** - Unique identifier provided by K2view cloud manager owner to associate your site with the agent
* **Cloud provider credentials** - Appropriate IAM roles or service accounts configured for your cloud provider (AWS/GCP/Azure)
* **Network access** - The agent pod must be able to reach:
  - Kubernetes API server
  - K2view cloud manager (`https://cloud.k2view.com`)
  - Your cloud provider APIs

## Values
Below is a table detailing the various configurable parameters for the K2view agent Helm chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespace.name | string | `"k2view-agent"` | Name of the namespace for the agent. |
| namespace.create | bool | `true` | Create new namespace for agent. |
| container.securityContext | bool | `false` | Enable security context for the container (supported only for k2view-agent version 2.11 and above). |
| container.image.url | string | `"docker.share.cloud.k2view.com/k2view/k2v-agent:2.10"` | URL for the K2view agent Docker image. |
| container.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the container. |
| container.image.addDockerRegistry | bool | `false` | Set true if you want to pull image from external repo, set false if your Kubernetes already have access to the repo. |
| container.image.dockerRegistrySecret | string | `"registry-secret"` | Name of the repository secret for private registry. |
| container.resources.requests.cpu | string | `"0.1"` | Agent container CPU requests. |
| container.resources.requests.memory | string | `"128Mi"` | Agent container memory requests. |
| container.resources.limits.cpu | string | `"0.4"` | Agent container CPU limit. |
| container.resources.limits.memory | string | `"256Mi"` | Agent container memory limit. |
| container.affinity.type | string | `"none"` | Affinity type: "affinity", "anti-affinity", or "none". |
| container.affinity.label.name | string | `"topology.kubernetes.io/zone"` | Node label name for affinity rules. |
| container.affinity.label.value | string | `"region-a"` | Node label value for affinity rules. |
| secrets | object |  | Configuration secrets for K2view agent. |
| secrets.K2_MAILBOX_ID | string | `""` | ID for K2view cloud manager, need to be provided by K2view cloud manager owner, used to associate site with agent (the ID unique and used for one agent). |
| secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com/api/mailbox"` | K2view cloud manager url. |
| secrets.kubeInterface | string | `"https://kubernetes.default.svc"` | Kubernetes API interface, need to be accessible from the agent. |
| secrets.CLOUD | string | `""` | Cloud provider (GCP\|AWS\|AZURE). |
| secrets.REGION | string | `""` | Cloud region. |
| secrets.SPACE_SA_ARN | string | `""` | For AWS only, IAM role ARN attached to the Kubernetes fabric namespace service account. |
| secrets.PROJECT | string | `""` | GCP project. |
| secrets.GCP_CONF_FILE | string | `""` | GCP service account json (in case used service account access mode). |
| secrets_from_file | object | `{}` | Configuration for secrets loaded from files. |
| secrets_from_file.TLS_KEY_PATH | string | `""` | Path to TLS private key file (will be base64 encoded twice). |
| secrets_from_file.TLS_CERT_PATH | string | `""` | Path to TLS certificate file (will be base64 encoded twice). |
| externalSecrets | list | `[]` | List of secrets to point environment variables to, used for secrets that not deployed by this helm, list of {secretName, key, varName}. |
| serviceAccount.name | string | `"k2view-agent"` | Service account name for agent. |
| serviceAccount.create | bool | `true` | Controls the creation of Kubernetes RBAC resources for the agent. When `true`, creates ServiceAccount, ClusterRole, ClusterRoleBinding, and a Secret containing the service account token. The agent pod automatically uses the kubeToken environment variable from this secret. When `false`, no RBAC resources are created and you must manually provide the `kubeToken` secret for the agent. |
| serviceAccount.attach | bool | `false` | Attach service account to agent pod. |
| serviceAccount.provider | string | `""` | Cloud provider (aws\|gcp\|azure). |
| serviceAccount.arn | string | `""` | For AWS only, deployer IAM role ARN, attached to Kubernetes agent namespace service account. |
| serviceAccount.gcp_service_account_name | string | `""` | For GCP only, service account name. |
| serviceAccount.project_id | string | `""` | For GCP only, project id. |
| serviceAccount.role.rules | list | See values.yaml | List of rules for Cluster role. |

* Get K2_MAILBOX_ID and K2_MANAGER_URL from your K2view contact.
* The kubeInterface should be accessible from the agent pod.

#### Additional secrets
Additional secrets are specified in the format key: "value". They are added to the agent-config-secrets and passed as environment variables to the agent container.

##### Common additional secrets
| Secret | Description |
|--------|-------------|
| `CLOUD` | The cloud provider: `AWS`, `GCP`, or `AZURE` |
| `REGION` | The cloud region where your cluster is located |
| `PROJECT` | GCP project ID (for GCP deployments) |
| `AWS_KEYSPACE_USER` | AWS Keyspace username (if using AWS Keyspace) |
| `AWS_KEYSPACE_PASSWORD` | AWS Keyspace password (if using AWS Keyspace) |
| `GCP_CONF_FILE` | GCP service account JSON (for service account access mode) |
| `SPACE_SA_ARN` | AWS IAM role ARN for Fabric spaces |
| `kubeToken` | Kubernetes Service Account token used by the agent to authenticate and interact with the Kubernetes API. |


### ServiceAccount Permissions
This chart requires a ServiceAccount with the following Kubernetes RBAC permissions.

#### Space Creation & Deletion
Required to create or delete a space (namespace) and its associated resources.

| Resources                                                                 | Verbs                             |
|---------------------------------------------------------------------------|-----------------------------------|
| `namespaces`, `services`, `persistentvolumeclaims`, `secrets`, `serviceaccounts`, `ingresses`, `networkpolicies` | `create`, `delete`, `get`, `list` |
| `horizontalpodautoscalers`                                               | `create`, `delete`, `get`, `list`, `patch` |

#### Project Deployment
Required to deploy Fabric project using Kubernetes Jobs.

| Resources              | Verbs                             |
|------------------------|-----------------------------------|
| `jobs`, `jobs/status`  | `create`, `delete`, `get`, `list` |

#### Cloud Manager Operations
Required for environment management and inspection.

| Resources                                                                 | Verbs                  |
|---------------------------------------------------------------------------|------------------------|
| `pods`, `pods/log`                                                        | `delete`, `get`, `list`|
| `nodes`                                                                   | `get`, `list`          |
| `events`                                                                  | `list`                 |
| `storageclasses`                                                          | `get`, `list`          |
| `namespaces`, `services`, `persistentvolumeclaims`                        | `get`, `list`          |
| `configmaps`, `secrets`, `serviceaccounts`                                | `get`, `list`, `patch` |
| `deployments`, `statefulsets`                                             | `get`, `list`, `patch` |

#### Central Monitoring Integration (K2View Sites Only)
Required to manage custom monitoring resources.

| Resources       | Verbs                |
|-----------------|----------------------|
| `podmonitors`   | `create`, `delete`   |


## Installation
### Clone and install from local
1. Clone this repository to your local machine:
```bash
git clone https://github.com/k2view/blueprints.git
cd blueprints/helm/k2view-agent/
```

2. Install
```bash
helm install k2view-agent --set secrets.K2_MAILBOX_ID="MY-MAILBOX-ID" .
```

### Install from helm repo
1. Add repo
```bash
helm repo add k2view-agent https://nexus.share.cloud.k2view.com/repository/k2view-agent
```

2. Install
```bash
helm install k2view-agent/k2view-agent k2view-agent --set secrets.K2_MAILBOX_ID="MY-MAILBOX-ID" .
```

## Additional Resources
### Cloud Provider Documentation
- [AWS IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- [AWS Keyspaces User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_keyspaces.html)
- [AWS EKS Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
- [GCP Service Account Keys](https://cloud.google.com/iam/docs/keys-create-delete)
- [GCP Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [Azure AKS Managed Identity](https://docs.microsoft.com/en-us/azure/aks/use-managed-identity)

### Kubernetes & Helm
- [Kubernetes RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Kubernetes Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [Helm Installation Guide](https://helm.sh/docs/intro/install/)
- [Helm Chart Development](https://helm.sh/docs/chart_template_guide/)
