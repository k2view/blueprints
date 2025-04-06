### Helm Charts Overview

This directory contains various Helm charts for deploying applications and services on Kubernetes clusters. Each Helm chart serves a specific purpose and simplifies the deployment process by packaging all the necessary Kubernetes manifests and configurations.

### Prerequisites

Before deploying these Helm charts, ensure that you have Helm installed on your Kubernetes cluster. 
If the prerequisites are not met and the Kubernetes cluster is not built, please refer to the main README for the Terraform setup instructions.


### Why Use These Helm Charts?

1. **Simplified Deployment**: Helm charts provide a convenient way to deploy complex applications with a single command, reducing manual configuration errors.
2. **Version Control**: Helm allows you to version control your deployments, making it easy to rollback to previous versions if needed.
3. **Community Support**: Helm has a large community contributing and maintaining Helm charts, ensuring compatibility and reliability.


### Helm Folders and Contents Overview

1. [aws](aws/): Contains Helm charts for AWS-related deployments.
2. [fabric](fabric/): Includes Helm charts for Fabric deployments.
3. [gcp](gcp/): Contains Helm charts for GCP-related deployments.
4. [generic-db](generic-db/): Contains Helm charts for generic database deployments like PostgreSQL on Kubernetes..
5. [ingress-nginx-k2v](ingress-nginx-k2v/): Includes Helm charts for Ingress NGINX K2V deployments.
6. [k2view-agent](k2view-agent/): Contains Helm charts for K2VIEW Agent deployments.