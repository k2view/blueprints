# K2view EKS BluePrint
This Terraform BluePrint aims to automate the creation and management of K2VIEW Kubernetes Related infrastructure resources on AWS.

## Requirements
To use this Terraform project, you will need the following prerequisites:

1. Tarraform - [hashicorp install guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. AWS cli - [AWS CLI](https://cloud-provider-link/cli)
3. Helm - [Helm install](https://helm.sh/docs/intro/install/)

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
git clone https://github.com/k2view/blueprints.git
cd aws/terraform/EKS
```

1. Set up your IAM User credentials. You can do this by setting the following environment variables.

```bash
export AWS_ACCESS_KEY_ID=
export AWS_ACCOUNT_ID=
```

>Depends on your setup you may need to config the IAM user, like login to awscli or add credentials to aws provider

## Usage
1. Review and customize the variables.tf file to set your desired configuration
2. Build Helm dependencies and Initialize Terraform:

```bash
cd Helm/k2-defaults
helm dependency build

cd ../../
terraform init
```

>helm dependency build required for charts that not included as a code like calico 

1. Then Using Default Terraform Commands you are able to plan, apply or destroy Infrastructre

```bash
terraform plan

terraform apply

terraform destroy
```

## Postactions 
Depend on values or setup you may need to do some aditional steps

### Perent DNS not configurated
In case the perent DNS can't be updated by this terraform (permissions/difrent service) you will posibly have this issues:
* Perent DNS not point to hosted zone on AWS side - If the domain not point to subdomain that created in rout53 please point to this subdomain from your domain.
* ACM certificate pending - If the domain not point to the subdomain the cert tifacate will be pending, after you fix the first step the approval can take few minutes.
* nginx ingress deployment pending - nginx ingress controller use certificate manages by AWS ACM, the controller will wate to ACM certificate to be issued.
* NLB not created - The NLB created by the nginx-ingress controller, it will take few minutes to be created after the ACM certificate issued.
* Hosted zone not point to NLB - If the NLB not created during the terraform run the A record that point to the NLB will net created.

#### Steps to fix the issue
1. Pont from your domanit to the subdomain that managed in AWS.
2. Wait to NLB to be created.
3. in the hosted zone (rout53) create A record of *.subdomain to this NLB.

#### Helpful links
<ul>
   <li><a href="https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html">Creating new subdomain in rout53</a></li>
</ul>

## Modules
| Name | Source | Version |
|------|--------|---------|
| <a name="module_create-a-record"></a> [create-a-record](#module\_create-a-record) | ./modules/Route53/create-a-record/ | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | ./modules/efs | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.17.2 |
| <a name="module_subdomain-hz"></a> [subdomain-hz](#module\_subdomain-hz) | ./modules/Route53/subdomain-hz/ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0 |
| <a name="module_irsa"></a> [irsa](#module\_irsa) | ./modules/irsa | n/a |

## Resources
| Name | Type |
|------|------|
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.k2view](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx-ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.sc-cassandra](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.sc-fabric](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.sc-pg](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lb.nginx-nlb](https://registry.terraform.io/providers/Hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [kubernetes_service.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run on | `string` | `"eu-central-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS cluster version | `string` | `"1.27"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain for rout53 (Example SUBDOMAIN.DOMAIN.COM) | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment Tag value (Dev/QA/Prod) | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EKS cluster instance type | `string` | `"m5.2xlarge"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner Tag value | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project Tag value | `string` | n/a | yes |
