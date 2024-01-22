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
5. Certbot installed

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
In order ot configure site domain copy the "ns" values of the DNS record of type "NS" created by terraform. The values also will be in the outputs of the terraform.
Go to relevant K2view AWS account (ReseachDevelopment/DFaaS) -> Route 53 -> Hosted zones.
Choose the relevant hosted zone and add a new record of type NS, fill the subdomain and Value (NS values from GCP) and click "Create records.

### Create Site SSL certificates
In order to create SSL certificate for the site, use the certbot command with your site domain.
```bash
sudo certbot certonly --manual -d *.[DOMAIN].k2view.com -d [DOMAIN].k2view.com --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --register-unsafely-without-email --rsa-key-size 4096
``` 
Follow the instructions. You will be asked to create a TXT record in the site DNS.
Go to GCP -> Cloud DNS, click on your DNS, click on "ADD STANDARD".
The record should look like `_acme-challenge.[CLUSTER_NAME].[MANAGER_NAME].k2view.com.`
Example: `_acme-challenge.my-cluster.cloud.k2view.com.`
Add the requested TXT values to the record.

### Configure custom error page
After you created the certificates copy the private key and the certificate contents to `helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets`.
Example:
```bash
sudo cat /etc/letsencrypt/live/[DOMAIN]/privkey.pem > helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets/key.pem
sudo cat /etc/letsencrypt/live/[DOMAIN]/fullchain.pem > helm/nginx-ingress/charts/nginx-ingress-controller-custom-errors/secrets/cert.pem
```
Than run again `terraform apply` to update the custom error pages helm release.

### Configure grafana monitoring
To configure grafana monitoring ask K2view representative to generate a token and supply grafana agent configuration file.
Paste the configuration to [grafana-agent-values.yaml](./grafana-agent-values.yaml) and run ```terraform apply```