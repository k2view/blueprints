# k2view-agent

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for k2view cloud manager site agent

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".password | string | `""` | External repo password. |
| image.repoSecret.dockerRegistry.auths."<REPO_URL>".username | string | `""` | External repo user. |
| image.repoSecret.enabled | bool | `false` | Set true if you want to pull image from external repo, set false if your k8s already have access to the repo. |
| image.repoSecret.name | string | `"registry-secret"` | Repo secret name. |
| image.url | string | `"docker.share.cloud.k2view.com/k2view/k2v-agent:latest"` | K2view agent image url. |
| namespace.create | bool | `true` | Create new namespace for agent. |
| namespace.name | string | `"k2view-agent"` | Namespace name. |
| resources.limits.cpu | string | `"0.4"` | agent container CPU limit. |
| resources.limits.memory | string | `"256Mi"` | agent container memory limit. |
| resources.requests.cpu | string | `"0.1"` | agent container CPU requests. |
| resources.requests.memory | string | `"128Mi"` | gent container memory requests. |
| role.name | string | `"k2view-agent"` | Agent role name. |
| secrets.K2_MAILBOX_ID | string | `""` | ID for K2view cloud manager, need to be provoided by K2view cloud manager owner, used to assosiate site with agent. |
| secrets.K2_MANAGER_URL | string | `"https://cloud.k2view.com/api/mailbox"` | K2view cloud manager url. |
| secrets.kubeInterface | string | `"https://kubernetes.default.svc"` | K8s API interface, need to be accessble from the agent. |
| secrets.kubeToken | string | `""` | Token to access k8s API, If serviceAccount.create is true this env will be ignored and will use the tocken of creates SA. |
| serviceAccount.create | bool | `true` | Create service account for agent. |
| serviceAccount.name | string | `"k2view-agent"` | Service account name for agent. |

* Get K2_MAILBOX_ID and K2_MANAGER_URL from your k2view contact.
* The kubeInterface should be accessible 

### Pull agent image
#### Vloud container registry
If you pull image from you cloud container registry (GCR/ECR/ACR) that you cluster have access to make sure to specify image url and the value of addDockerRegistry is false.

#### External container registry (nexus)
If you pull image from k2view nexus or you private nexus specify this parameters 

```yaml
dockerRegistry:
  auths:
    "<REPO_URL>":
      username: "<USER_NAME>"
      password: "<PASSWORD>"
```

* make sure the value of image.repoSecret.enabled is true

#### Additional secrets
Each secret (key:"value") will be added to agent-config-secrets secret and to agent container as a environment variable
