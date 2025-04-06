# K2VIEW Infrastructure Blueprints
Welcome to the K2VIEW Infrastructure Blueprints repository. 
This repository serves as a collection of various infrastructure blueprints that are designed and maintained by K2VIEW's infrastructure team. 
These blueprints provide pre-defined templates and configurations for setting up and managing different types of environments and architectures.

## Introduction
At K2VIEW, we understand the importance of efficient infrastructure management to support our growing business needs. Infrastructure blueprints are a fundamental part of our infrastructure-as-code approach, enabling us to automate the provisioning and management of our infrastructure components.

## What They Are
The blueprints in this repository are categorized based on the type of environment and the cloud provider. Each blueprint contains templates and scripts to set up and manage infrastructure components efficiently.

## Getting Started
These blueprints are designed to be flexible and customizable. You can:

1. Choose the template that best fits your use case
2. Use the template as-is for standard deployments
3. Modify and adapt the templates to match your specific requirements
4. Build upon the templates to create more specialized configurations

We encourage users to treat these blueprints as starting points rather than rigid structures. Feel free to:
- Customize configuration parameters
- Add or remove components based on your needs
- Extend functionality with additional modules
- Adapt security settings to match your organization's requirements
- Optimize resource allocations for your specific workloads

The modular nature of these blueprints makes them easily adaptable while maintaining infrastructure best practices and security standards.

## Available Infrastructure Blueprints
Each blueprint category contains detailed documentation and examples in its respective README.md file.
in the following templates the assumption that no pre-defined Infra exist. 

### AWS Blueprint
Blueprint for setting up and managing infrastructure on AWS.
- **Template:** [aws-template](Terraform/aws-template/)

### Azure Blueprint
Blueprint for setting up and managing infrastructure on Azure.
- **Template:** [azure-template](Terraform/azure-template/)

### GCP Blueprint
Blueprint for setting up and managing infrastructure on GCP.
- **Template:** [gcp-template](Terraform/gcp-template/)

### Baremetal Blueprints
Blueprints for setting up and managing baremetal environments.
- **Scripts:**
  - [bubbles.sh](baremetal/bubbles.sh)
  - [deploy_certificate.sh](baremetal/deploy_certificate.sh)
  - [docker-registry.yaml](baremetal/docker-registry.yaml)
  - [k8s-setup.sh](baremetal/k8s-setup.sh)
  - [single_node.sh](baremetal/single_node.sh)
  - [static/](baremetal/static/)

### Docker Blueprints
Blueprints for setting up and managing Docker environments.
- **Fabric Studio:**
  - [fabric-studio](Docker/Studio/)
    - supported profiles, [stand-alone with/out cassandra and/or postgress]


### Helm Deployment & resources
to use the helm, the assupmtion is that you already have running K8s env.
Blueprints for setting up and managing Helm charts.
- **AWS:** [aws](helm/aws/)
- **Fabric:** [fabric](helm/fabric/)
- **GCP:** [gcp](helm/gcp/)
- **Generic DB:** [generic-db](helm/generic-db/)
- **Ingress NGINX K2V:** [ingress-nginx-k2v](helm/ingress-nginx-k2v/)
- **K2VIEW Agent:** [k2view-agent](helm/k2view-agent/)


Feel free to explore the repository and use the blueprints as needed for your infrastructure requirements.

## Repository Structure
The repository is organized as follows:
```markdown
.
├── Docker
│   └── Studio
├── baremetal
│   └── static
├── Terraform
│   ├── aws-template
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── azure-template
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── gcp-template
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── modules
│       ├── aws
│       │   ├── dns
│       │   ├── irsa
│       │   ├── k8s
│       │   └── network
│       ├── azure
│       │   ├── acr
│       │   ├── aks
│       │   ├── iam
│       │   ├── network
│       │   ├── resource-group
│       │   └── storage-account
│       ├── gcp
│       │   ├── gke
│       │   ├── gke-v-31
│       │   ├── iam
│       │   ├── nat-instance
│       │   ├── network
│       │   ├── secrets-store-csi-driver-provider-gcp
│       │   └── storage-class
│       └── shared
│           ├── external-secret-operator
│           ├── ingress-controller
│           ├── k2view-agent
│           └── secret-store-csi
├── helm
│   ├── aws
│   │   └── storage-classes
│   ├── fabric
│   ├── gcp
│   │   ├── gcp-pd-storage-class
│   │   └── secrets-store-csi-driver-provider-gcp
│   ├── generic-db
│   ├── ingress-nginx-k2v
│   ├── k2v-ingress
│   └── k2view-agent
└── README.md
```

