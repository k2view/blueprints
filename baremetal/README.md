# K2cloud On-prem K8s Cluster Setup

Here you can find the scripts that streamline the installation and configuration of the K2cloud on-premises Kubernetes solution. Once installed, the created Kubernetes cluster becomes a K2cloud Platform site, ready for operation.

K2view prerequisites and minimum hardware requirements can be consulted [here](https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Hardware/2_All_Environments/04_Requirements_and_Prerequisites_for_K2cloud_on-prem_K8s_Installation.html).

Kubernetes (kubelet) will be deployed through kubeadm along with some addons and management tools.

Out-of-the-box, it will install the latest version of all components, but those can be specified via exported environment variables. To ensure the consistency and integrity of customized parameters during automated deployments, all parameters can be set in a file 'k8s-setup.env', which must be placed in the exact location as the setup script 'k8s-setup.sh '.

## kubeadm

Before installing Kubernetes, the swap and the internal firewall must be disabled. (Important: those steps will NOT be configured automatically during the execution of our installation script!)

The official documentation for kubeadm installation can be found at this link: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


## k8s-setup.sh

When deploying Kubernetes through our automated setup script 'k8s-setup.sh', a series of settings in your system will be modified. k8s-setup.sh will also install some applications required to run Kubernetes.

### Linux configurations:

k8s-setup.sh will change the following settings:

- Enable IP forwarding (as `sysctl net.ipv4.ip_forward=1`)
- Disable SELinux (as `setenforce 0`)

### Container runtime

Kubernetes uses a container runtime to run pods (a list of all supported runtimes can be found in the link above). If none is installed, k8s-setup.sh will install and configure containerd as a container runtime. If containerd is already installed and its service is running, no modifications to its settings will be made. If that's the case, please ensure all parameters required by kubeadm are set.

### Addons

The following addons will be automatically installed in your Kubernetes cluster:

- [Tigera's Calico](https://www.tigera.io/project-calico/), a Container Network Interface
- [Rancher's Local Path Provisioner](https://github.com/rancher/local-path-provisioner), a Storage Class called local-path, used to create Persistent Volumes using the host's filesystem
- [Distribution's Registry](https://distribution.github.io/distribution/), a private Container Registry (requires containerd to be used as container runtime)
- [MetalLB](https://metallb.io/), a network Load Balancer for the cluster
- [K8s's Ingress-NGINX](https://kubernetes.github.io/ingress-nginx/), an Ingress Controller (plus additional components like error page handler / ingress test)
- [K2view-agent](https://github.com/k2view/blueprints/blob/main/helm/k2view-agent/README.md), an application that communicates with our Cloud Orchestrator

Note:
- local-path Storage Class uses the directory "/opt/local-path-provisioner" in the host to store the Persistent Volumes
- docker-registry Container Registry stores all its data in a local-path Persistent Volume
- Helm is used to deploy some of the addons and will be automatically installed by k8s-setup.sh

### Private container registry

A private container registry can be configured if containerd is used for container runtime.

To push images to this private container registry, pull or load (import) the desired image (Docker will not be installed by default, but you can use `ctr` as long as you can run *sudo*)

```
# Pull the desired image
sudo ctr image pull -u <USERNAME> docker.share.cloud.k2view.com/k2view/fabric-studio:8.0.0_123

# OR import desired image (note: the image cannot be compressed)
sudo ctr image import /path/to/fabric-studio-8.0.0_123.tar

# Retag image
sudo ctr image tag docker.share.cloud.k2view.com/k2view/fabric-studio:8.0.0_123 registry.localhost/k2view/fabric-studio:8.0.0_123

# push image to private container registry
sudo ctr image push --plain-http registry.localhost/k2view/fabric-studio:8.0.0_123
```

Now you can instruct the Cloud Orchestrator to use the image from your private container registry.
