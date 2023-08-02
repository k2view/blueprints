# K2view EKS BluePrint

This Terraform BluePrint aims to automate the creation and management of K2VIEW Kubernetes Related infrastructure resources on AWS.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)

## Requirements

To use this Terraform project, you will need the following prerequisites:

1. [Terraform](https://www.terraform.io/downloads.html)

2. [AWS CLI](https://cloud-provider-link/cli)

3. [Helm](https://helm.sh/docs/intro/install/)

4. AWS IAM User

   You will need an AWS IAM User with appropriate permissions to run Terraform and manage AWS resources. Ensure that the IAM User has the following policies attached:

   - AmazonEC2FullAccess
   - AmazonVPCFullAccess
   - AmazonEKSClusterPolicy
   - AmazonEKSWorkerNodePolicy
   - AmazonEKS_CNI_Policy
   - AmazonEKSServicePolicy
   - AmazonEKSFargatePodExecutionRolePolicy
   - AmazonEKS_Pod_Execution_Role_Policy
   - AmazonS3FullAccess
   - AmazonRoute53FullAccess
   - AWSCertificateManagerFullAccess

5. [Setup Metrics Write Permission](https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-managed#explicit-credentials) 

   In addition to the AWS IAM User credentials, you will need to set up the Metrics Write permission for a GCP Service Account. You should have a GCP service account JSON key file named `metricsWriter.json`. This service account is used for writing metrics to Google Cloud Monitoring when using the GCP Monitoring Collectors Helm Chart.

   After obtaining the `metricsWriter.json` key file, place it in the following directory: Helm/k2-defaults/charts/gcp-monitoring-collectors/additionals/

## Installation

1. Clone this repository to your local machine:

```bash
git clone https://github.com/k2view-academy/Blueprints.git
cd aws/terraform/eks
```

1. Set up your IAM User credentials. You can do this by setting the following environment variables.

```bash
export AWS_ACCESS_KEY_ID=
export AWS_ACCOUNT_ID=
```

## Usage

1. Review and customize the variables.tf file to set your desired configuration
2. Build Helm dependencies and Initialize Terraform:

```bash
cd Helm/k2-defaults
helm dependency build

cd ../../
terraform init
```

1. Then Using Default Terraform Commands you are able to plan, apply or destroy Infrastructre

```bash
terraform plan

terraform apply

terraform destroy
```

## Directory Structure

Relavent structure of this Terraform project is organized as follows:

```css
.
├── provider.tf
├── data.tf
├── main.tf
├── variables.tf
├── helm.tf
├── cloudformations
│   └── karpenter.yaml
├── modules
│   │
│   └── Route53
│       ├── subdomain-hz
│       └── create-a-record
└── Helm
    └── k2-defaults
        └── charts
            ├── nginx-ingress
            │   └── templates
            │       ├── 01-ingress-controller.yaml
            │       ├── NOTES.txt
            │       └── 02-test-pod.yaml
            ├── permission-access
            │   └── templates
            │       └── full-admin-user.yaml
            │
            └── gcp-monitoring-collectors
                ├── additionals
                │   └── config.yml
                ├── crds
                │   └── 01-resource-extension.yaml
                ├── templates
                │   ├── 02-operator.yaml
                │   ├── 07-promtail.yaml
                │   ├── 03-self-prom-metrics.yaml
                │   ├── 06-yace.yaml
                │   └── 04-kube-state-metrics.yaml
                └── README.md
```