# k2view-agent

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.17.0](https://img.shields.io/badge/AppVersion-1.17.0-informational?style=flat-square)

This Helm chart is used for deploying the K2view cloud manager site agent.

## Pre-requisites
* Helm - [Helm install](https://helm.sh/docs/intro/install/)
* MAILBOX ID - ID for K2view cloud manager, needs to be provided by K2view cloud manager owner, used to associate site with agent (the ID is unique and used for one agent).
* Access to Kubernetes cluster

## Values
Below is a table detailing the various configurable parameters for the K2view agent Helm chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.url | string | `"docker.share.cloud.k2view.com/k2view/k2v-agent:latest"` | URL for the K2view agent Docker image. |
| image.repoSecret.enabled | bool | `false` | Set true if you want to pull image from external repo, set false if your k8s already have access to the repo. |
| image.repoSecret.name | string | `"registry-secret"` | Name of the repository secret. |
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".password | string | `""` | External repo password. |
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".username | string | `""` | External repo user. |
| namespace.name | string | `"k2view-agent"` | Name of the namespace for the agent. |
| namespace.create | bool | `true` | Create new namespace for agent. |
| resources.requests.cpu | string | `"0.1"` | Agent container CPU requests. |
| resources.requests.memory | string | `"128Mi"` | Agent container memory requests. |
| resources.limits.cpu | string | `"0.4"` | Agent container CPU limit. |
| resources.limits.memory | string | `"256Mi"` | Agent container memory limit. |
| role.name | string | `"k2view-agent"` | Name of the agent role. |
| secrets | list |  | List of secrets for K2view agent, list of name and value. |
| secrets.K2_MAILBOX_ID | string | `""` | ID for K2view cloud manager, needs to be provided by K2view cloud manager owner, used to associate site with agent (the ID is unique and used for one agent). |
| secrets.SPACE_SA_ARN | string | `""` | For aws only, iam role arn attached to the k8s fabric namespace service account |
| secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com/api/mailbox"` | K2view cloud manager url. |
| secrets.kubeInterface | string | `"https://kubernetes.default.svc"` | K8s API interface, needs to be accessible from the agent. |
| secrets.kubeToken | string | `""` | Token to access k8s API, If serviceAccount.create is true this env will be ignored and will use the token of created SA. |
| secrets_from_file.TLS_KEY_PATH | string | `""` | Path to TLS private key file (will be base64 encoded twice). |
| secrets_from_file.TLS_CERT_PATH | string | `""` | Path to TLS certificate file (will be base64 encoded twice). |
| externalSecrets | list | `""` | List of secrets to point environment variables to, used for secrets that are not deployed by this helm, list of {secretName, key, varName}. |
| serviceAccount.name | string | `"k2view-agent"` | Service account name for agent. |
| serviceAccount.create | bool | `true` | Create service account for agent. |
| serviceAccount.attach | bool | `false` | Attach service account to agent pod. |
| serviceAccount.role.name | string | `"k2view-agent"` | Cluster role that will be attached to agent service account. |
| serviceAccount.role.rules | list |  | List of rules for Cluster role. |
| serviceAccount.provider | string | `""` | aws or gcp. |
| serviceAccount.arn | string | `""` | For aws only, deployer iam role arn, attached to k8s agent namespace service account. |
| serviceAccount.gcp_service_account_name | string |`""`| For gcp only, service account name. |
| serviceAccount.project_id | string |`""`| For gcp only, project id. |

* Get K2_MAILBOX_ID and K2_MANAGER_URL from your K2view contact.
* The kubeInterface should be accessible 

### Pull agent image
#### Cloud container registry
If you pull image from your cloud container registry (GCR/ECR/ACR) that you cluster have access to make sure to specify image url and the value of addDockerRegistry is false.

#### External container registry (Nexus)
If you pull image from K2view nexus or your private nexus specify these parameters 

```yaml
dockerRegistry:
  auths:
    "<REPO_URL>":
      username: "<USERNAME>"
      password: "<PASSWORD>"
```

* In this case make sure the value of image.repoSecret.enabled is true

#### Additional secrets
Additional secrets are specified in the format key: "value". They are added to the agent-config-secrets and passed as environment variables to the agent container.

##### Common additional secrets
CLOUD                 - The cloud provider AWS|GCP|AZURE.\
REGION                - The cloud region.\
PROJECT               - GCP project.\
AWS_KEYSPACE_USER     - AWS Keyspace username.\
AWS_KEYSPACE_PASSWORD - AWS Keyspace password.\
AWS_ACCESS_KEY_ID     - AWS IAM user key id (in case used user access mode).\
AWS_SECRET_ACCESS_KEY - AWS IAM user key secret (in case used user access mode).\
GCP_CONF_FILE         - GCP service account json (in case used service account access mode).\
SPACE_SA_ARN          - AWS deployer IAM role ARN.

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

#### TLS Certificate
If you want to deploy your own TLS certificate, execute the following:
1. Create your TLS certificate files - private key and certificate.
2. Copy your certificate files to "secrets" directory
3. Change "secrets_from_file.TLS_KEY_PATH" and "secrets_from_file.TLS_CERT_PATH" if needed
4. Install the agent

* The contents of private key and certificate will be base64 encoded twice to enable storing them encoded in agent environment variables.

Example:
```bash
helm install k2agent --set secrets_from_file.TLS_KEY_PATH='secrets/key.pem',secrets_from_file.TLS_CERT_PATH='secrets/cert.pem' .
```

## For more information, read below:

[ AWS Keyspaces user ](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_keyspaces.html)\
[ AWS IAM user ](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)\
[ GCP service account keys ](https://cloud.google.com/iam/docs/keys-create-delete)\
[ Pull an Image from a Private Registry ](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
