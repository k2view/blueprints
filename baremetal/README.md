# Kubernetes and Git Installation Script

## Introduction
This script automates the installation and configuration of Kubernetes (MicroK8s), Git, Docker, and other related tools on Linux and MacOS systems. It uses the "charm gum" utility for enhanced text output and user interaction.
This script installs K2View Agent and configures the cluster as a Cloud Manager site.

## Features
- Automatic detection and handling of Linux and MacOS environments.
- Installation of Git, Docker, and Kubernetes (MicroK8s).
- Configuration of Kubernetes with essential add-on.
- Installs and Configure K2View Agent.
- Visual feedback for operation success or failure.


## Prerequisites
- Bash shell
- For MacOS: Homebrew must be installed.
- For MacOS (Arm64): Homebrew and **Docker** must be installed
- For Linux: Ubuntu 20.04 or higher and a user with sudo privileges.

## The following tools will be installed:
|Name            |Required |More info                                 |
|----------------|---------|------------------------------------------|
|Microk8s        |Linux    |https://microk8s.io/                      |
|Minikube        |MacOS    |https://minikube.sigs.k8s.io/docs/        |
|Git             |Yes      |https://git-scm.com/                      |
|cert-manager    |Yes      |https://cert-manager.io/                  |
|NGINX Ingress   |Yes      |https://docs.nginx.com/                   |
|hostpath-storage|Yes      |                                          |
|docker registry |Yes      |https://microk8s.io/docs/registry-built-in|
|metrics-server  |Yes      |                                          |
|k2-agent        |Yes      |helm/charts/k2view-agent                  |

Additional Tools: kubectl and helm will be installed.

## Installation (Linux and MacOS)

To run the script, run the following commands:

```
cd blueprints/baremetal
./single_node.sh 
```

And hit `Confirm` to proceed.

The installation process is fully automatic and requires little user intervention.

After complete Kubernetes installation, you will need to Enter the following parameters to install and register the K2View Agent.

|Parameter       |Description                 |
|----------------|----------------------------|
|MANAGER URL     | Cloud Manager URL          |
|MAILBOX ID      | Obtained from K2View       |
|* K2View Agent Helm Repository| Defaults to K2View Agent|

* You may use your own K2View Agent Helm repository, Please make sure that you have added the repository to your Helm repository using

***Linux***: `microk8s helm repo add` and `microk8s helm repo update` commands.

***MacOS***: `helm repo add` and `repo update` commands.

---
## Network and Load Balancing

By default the K2View Fabric use `NGINX Ingress Controller` but you can configure any network load balancing technology and associated with the DNS configurations.

Please note that the DNS domain should be the same the one registered in Cloud Manager.

---

## Starting and Stopping the Cluster and Services 

#### Linux Only

Use the following commands to stop and restart the cluster:

**Stoping The Cluster**
`microk8s stop`


**Starting The Cluster**
`microk8s start`

**Restarting The Cluster**
`microk8s restart`

#### MacOS Only

Use the following commands to stop and restart the cluster:

**Stoping The Cluster**
`minikube stop`

**Starting The Cluster**
`minikube start`

**Restarting The Cluster**
`minikube restart`

---

## Adding more RAM and CPU to the cluster
**Linux Only**

 Adding more memory to a MicroK8s cluster involves increasing the memory resources of the underlying nodes (machines) where MicroK8s is running. MicroK8s itself doesn't manage the hardware directly; it runs on top of the host system. Therefore, you need to manage memory at the level of the host operating system or the virtualization layer if you are using VMs or cloud instances.

**MacOS Only**
If you've already started your Minikube cluster and want to modify the allocated resources, you'll need to stop the cluster, delete it, and start it again with the new resource specifications.

1- Stop the Minikube Cluster:

```minikube stop```

2- Delete the Minikube Cluster:

```minikube delete```

3- Rerun this script and enter new resource values during the installation:

***Important Notes:***

Deleting your Minikube cluster will remove all existing configurations, deployed applications, and data within the cluster. Ensure that you back up any important data before doing this.

If you only need to temporarily allocate more resources for a specific workload, consider adjusting the resources at the Kubernetes pod or deployment level instead of changing the entire Minikube setup.

After increasing resources, you might also want to check and adjust the resource requests and limits in your Kubernetes workloads to better utilize the additional resources.

---

**Uninstalling The Cluster**

Delete the spaces and other resources from the Cloud Manager and then use the following commands to remove the cluster from your machine.

Linux only: `microk8s uninstall`

MacOS only: `minikube uninstall`



## Fabric Docker Images
The Kubernetes Cluster is configured to run a Docker registry.
You are required to `manually` store the Fabric images in the local Docker registry installed on the Kubernetes cluster.
