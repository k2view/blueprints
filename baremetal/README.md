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
- For Linux: Apt package manager and sudo privileges.

## The following tools will be installed:
|Name            |Required |More info                                 |
|----------------|---------|------------------------------------------|
|Microk8s        |Yes      |https://microk8s.io/                      |
|Git             |Yes      |https://git-scm.com/                      |
|cert-manager    |Yes      |https://cert-manager.io/                  |
|NGINX Ingress   |Yes      |https://docs.nginx.com/                   |
|hostpath-storage|Yes      |                                          |
|docker registry |Yes      |https://microk8s.io/docs/registry-built-in|                           |
|metrics-server  |Yes      |                                          |
|k2-agent        |Yes      |helm/charts/k2view-agent                  |


Additional Tools: kubectl and helm will be installed.


## Installation

To run the script, run the following commands:

```
cd bin
./single_node.sh 
``````

And confirm to proceed.

The installation process is fully automatic and requires little user intervention.

After complete Kubernetes installation, you will need to Enter the following parameters to install and register the K2View Agent.

|Parameter       |Description                 |
|----------------|----------------------------|
|MANAGER URL     | Cloud Manager URL          |
|MAILBOX ID      | Obtained from K2View       |


## Network and Load Balancing

By default the K2View Fabric use `NGINX Ingress Controller` but you can configure any network load balancing technology and associated DNS configurations.

Please note that the DNS domain should be the same the one registered in Cloud Manager.


## Fabric Docker Images
The Kubernetes Cluster is configured to run a Docker registry.
You are required to `manually` store the Fabric images in the local Docker registry installed on the Kubernetes cluster.
