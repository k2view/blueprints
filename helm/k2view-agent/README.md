# k2view-agent

![Version: 1.1.9](https://img.shields.io/badge/Version-1.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5](https://img.shields.io/badge/AppVersion-2.5-informational?style=flat-square)

This Helm chart simplifies the deployment of the K2view cloud manager site agent, ensuring a streamlined integration with your cloud infrastructure.

## Pre-requisites
* Helm - [Helm install](https://helm.sh/docs/intro/install/)
* MAILBOX ID - ID for K2view cloud manager, need to be provided by K2view cloud manager owner, used to associate site with agent (the ID unique and used for one agent).
* Access to Kubernetes cluster

## Values
Below is a table detailing the various configurable parameters for the K2view agent Helm chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.url | string | `"docker.share.cloud.k2view.com/k2view/k2v-agent:2.5"` | URL for the K2view agent Docker image. |
| image.repoSecret.enabled | bool | `false` | Set true if you want to pull image from external repo, set false if your k8s already have access to the repo. |
| image.repoSecret.name | string | `"registry-secret"` | Name of the repository secret. |
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".password | string | `""` | External repo password. |
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".username | string | `""` | External repo user. |
| namespace.name | string | `"k2view-agent"` | Name of the namespace for the agent. |
| namespace.create | bool | `true` | Create new namespace for agent. |
| resources.requests.cpu | string | `"0.1"` | agent container CPU requests. |
| resources.requests.memory | string | `"128Mi"` | agent container memory requests. |
| resources.limits.cpu | string | `"0.4"` | agent container CPU limit. |
| resources.limits.memory | string | `"256Mi"` | agent container memory limit. |
| secrets | object |  | Configuration secrets for K2view agent. |
| secrets.K2_MAILBOX_ID | string | `""` | ID for K2view cloud manager, need to be provided by K2view cloud manager owner, used to associate site with agent (the ID unique and used for one agent). |
| secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com/api/mailbox"` | K2view cloud manager url. |
| secrets.kubeInterface | string | `"https://kubernetes.default.svc"` | K8s API interface, need to be accessible from the agent. |
| secrets.CLOUD | string | `""` | Cloud provider (GCP\|AWS). |
| secrets.REGION | string | `""` | Cloud region. |
| secrets.SPACE_SA_ARN | string | `""` | For AWS only, IAM role ARN attached to the k8s fabric namespace service account. |
| secrets.PROJECT | string | `""` | GCP project. |
| secrets.GCP_CONF_FILE | string | `""` | GCP service account json (in case used service account access mode). |
| secrets_from_file.TLS_KEY_PATH | string | `""` | Path to TLS private key file (will be base64 encoded twice). |
| secrets_from_file.TLS_CERT_PATH | string | `""` | Path to TLS certificate file (will be base64 encoded twice). |
| externalSecrets | list | `[]` | List of secrets to point environment variables to, used for secrets that not deployed by this helm, list of {secretName, key, varName}. |
| serviceAccount.name | string | `"k2view-agent"` | Service account name for agent. |
| serviceAccount.create | bool | `true` | Create service account for agent. |
| serviceAccount.attach | bool | `false` | Attach service account to agent pod. |
| serviceAccount.provider | string | `""` | Cloud provider (aws\|gcp). |
| serviceAccount.arn | string | `""` | For AWS only, deployer IAM role ARN, attached to k8s agent namespace service account. |
| serviceAccount.gcp_service_account_name | string | `""` | For GCP only, service account name. |
| serviceAccount.project_id | string | `""` | For GCP only, project id. |
| serviceAccount.role.rules | list | See values.yaml | List of rules for Cluster role. |

* Get K2_MAILBOX_ID and K2_MANAGER_URL from your K2view contact.
* The kubeInterface should be accessible from the agent pod.

#### Additional secrets
Additional secrets are specified in the format key: "value". They are added to the agent-config-secrets and passed as environment variables to the agent container.

##### Common additional secrets
CLOUD                 - The cloud provider AWS|GCP|AZURE.\
REGION                - The cloud region.\
PROJECT               - GCP project.\
AWS_KEYSPACE_USER     - AWS Keyspace username.\
AWS_KEYSPACE_PASSWORD - AWS Keyspace password.\
GCP_CONF_FILE         - GCP service account json (in case used service account access mode).\
SPACE_SA_ARN          - AWS deployer IAM role ARN.


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
| `pods`                                                                    | `delete`, `get`, `list`|
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

## For more information, read below:
[ AWS Keyspaces user ](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_keyspaces.html)\
[ AWS IAM user ](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)\
[ GCP service account keys ](https://cloud.google.com/iam/docs/keys-create-delete)\
[ Pull an Image from a Private Registry ](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
