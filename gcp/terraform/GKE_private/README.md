# Create Private Site

This document describes how to create cloud manager site with private nodes, meaning traffic from all the nodes will come from a single IP address which could be whitelisted in security systems.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP Project Name | string | - | yes |
| region | GCP Region | string | europe-west3 | yes |
| cluster_name | The name of the GKE cluster | string | - | yes |
| domain | Domain name for ingress traffic | string | - | yes |
| k2view_agent_namespace | The name of K2view agent namespace | string | k2view-agent | no |
| deploy_grafana_agent | A boolean flag to control whether to install grafana agent | boolean | false | no |
| network_name | VPC network name | string | - | no |
| subnet_cidr | Primary CIDR range for a subnet | string | 10.130.0.0/16 | no |
| secondary_cidr_pods | Secondary CIDR range for pods | string | 10.176.0.0/14 | no |
| secondary_cidr_services | Secondary CIDR range for services | string | 10.180.0.0/20 | no |
| machine_type | The GCP VM type for workerr nodes | string | e2-highmem-4 | no |
| min_node | The minimum workers up | number | 1 | no |
| max_node | The maximum workers up | number | 3 | no |
| initial_node_count | The initial workers up | number | 1 | no |
| disk_size_gb | The boot disk size in GB for worker nodes | number | 500 | no |
| disk_type | The disk type for cluster workers | string | pd-standard | no |

## Pre-requisites

1. GCP Account with Owner role in the relevant project
2. Terraform installed
3. Kubectl installed
4. Helm installed

## Site Creation

### Clone the repository and configure the project

First clone the repository
```bash
git clone https://github.com/k2view/blueprints.git
cd blueprints/gcp/terraform/Environments/cloud_site_private
```

Copy [terraform.tfvars.template](./terraform.tfvars.template) to "terraform.tfvars" and fill the values.
```bash
cp terraform.tfvars.template terraform.tfvars
```
Make sure to set the required variables.

**IMPORTANT**
To disable monitoring set "deploy_grafana_agent" to "false".
If you want to enable the monitoring, first [configure Grafana Cloud](#configure-grafana-monitoring)

### Initialize Terraform, plan and apply
After the values are populated in "terraform.tfvars" initialize terraform, plan and apply.
```bash
terraform init
terraform plan
terraform apply
```

### Configure Site Domain
If you want your site domain name to be configured in K2view DNS copy the "ns" values of the DNS record of type "NS" created by terraform and provide to K2view representative.

### Create Site SSL certificates
If you want to use your own SSL certificates for the site, provide the certificate and the private key to K2view representative.

### Configure custom error page
Copy the private key and the certificate contents to `helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets`.
Example:
```bash
cat [YOUR_PRIVATE_KEY] > helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets/key.pem
cat [YOUR_CERTIFICATE] > helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets/cert.pem
```
Than run again `terraform apply` to update the custom error pages helm release.

### Configure grafana monitoring
To configure grafana monitoring ask K2view representative to generate a token and supply grafana agent configuration file.
Paste the configuration to [grafana-agent-values.yaml](./grafana-agent-values.yaml) and run ```terraform apply```