## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.81.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.81.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster-autoscaler"></a> [cluster-autoscaler](#module\_cluster-autoscaler) | [../modules/aws/k8s/autoscaler](../modules/aws/k8s/autoscaler) | n/a |
| <a name="module_dns-a-record"></a> [dns-a-record](#module\_dns-a-record) | [../modules/aws/dns/dns-a-record](../modules/aws/dns/dns-a-record) | n/a |
| <a name="module_dns-hosted-zone"></a> [dns-hosted-zone](#module\_dns-hosted-zone) | [../modules/aws/dns/dns-hosted-zone](../modules/aws/dns/dns-hosted-zone) | n/a |
| <a name="module_ebs"></a> [ebs](#module\_ebs) | [../modules/aws/k8s/storage-classes/ebs](../modules/aws/k8s/storage-classes/ebs) | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | [../modules/aws/k8s/storage-classes/efs](../modules/aws/k8s/storage-classes/efs) | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | [../modules/aws/k8s/eks](../modules/aws/k8s/eks) | n/a |
| <a name="module_ingress-controller"></a> [ingress-controller](#module\_ingress-controller) | [../modules/shared/ingress-controller](../modules/shared/ingress-controller) | n/a |
| <a name="module_irsa"></a> [irsa](#module\_irsa) | [../modules/aws/irsa](../modules/aws/irsa) | n/a |
| <a name="module_k2view-agent"></a> [k2view-agent](#module\_k2view-agent) | [../modules/shared/k2view-agent](../modules/shared/k2view-agent) | n/a |
| <a name="module_vpc_cluster"></a> [vpc\_cluster](#module\_vpc\_cluster) | [../modules/aws/network/](../modules/aws/network/) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.efs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.efs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_vpc.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_record.dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_ebs_volume.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [kubernetes_storage_class.ebs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_deployment.ingress_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.k2view_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Amazon Linux 2 AMI type | `string` | `"AL2_x86_64"` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | EKS authentication mode | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | <pre>[<br>  "euc1-az1",<br>  "euc1-az2"<br>]</pre> | no |
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | AWS access key ID | `string` | n/a | yes |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | AWS secret access | `string` | n/a | yes |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | capacity type | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of subnet CIDRs | `list(string)` | <pre>[<br>  "10.5.5.0/24",<br>  "10.5.6.0/24"<br>]</pre> | no |
| <a name="input_deploy_autoscaler"></a> [deploy\_autoscaler](#input\_deploy\_autoscaler) | A boolean flag to control whether to install cluster autoscaler agent | `bool` | `true` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of workers | `number` | `1` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain will be used for ingress | `string` | n/a | yes |
| <a name="input_efs_enabled"></a> [efs\_enabled](#input\_efs\_enabled) | Flag to enable or disable EFS module | `bool` | `false` | no |
| <a name="input_eks_cluster_endpoint_public_access"></a> [eks\_cluster\_endpoint\_public\_access](#input\_eks\_cluster\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_eks_max_worker_count"></a> [eks\_max\_worker\_count](#input\_eks\_max\_worker\_count) | The maximum workers up | `number` | `3` | no |
| <a name="input_eks_min_worker_count"></a> [eks\_min\_worker\_count](#input\_eks\_min\_worker\_count) | The minimum workers up | `number` | `1` | no |
| <a name="input_enable_cluster_creator_admin_permissions"></a> [enable\_cluster\_creator\_admin\_permissions](#input\_enable\_cluster\_creator\_admin\_permissions) | Grant additional permissions to the creator of the cluster | `bool` | `true` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Set of instance types associated with the EKS Node Group | `list(string)` | <pre>[<br>  "m5.2xlarge"<br>]</pre> | no |
| <a name="input_k2view_agent_namespace"></a> [k2view\_agent\_namespace](#input\_k2view\_agent\_namespace) | The name of K2view agent namespace | `string` | `"k2view-agent"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version of the EKS cluster | `string` | `"1.30"` | no |
| <a name="input_mailbox_id"></a> [mailbox\_id](#input\_mailbox\_id) | k2view cloud mailbox ID | `string` | `""` | no |
| <a name="input_mailbox_url"></a> [mailbox\_url](#input\_mailbox\_url) | k2view cloud mailbox URL | `string` | `"https://cloud.k2view.com/api/mailbox"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network | `string` | `""` | no |
| <a name="input_private_cluster"></a> [private\_cluster](#input\_private\_cluster) | Flag to enable or disable private cluster | `bool` | `false` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet CIDRs | `list(string)` | <pre>[<br>  "10.5.3.0/24",<br>  "10.5.4.0/24"<br>]</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet CIDRs | `list(string)` | <pre>[<br>  "10.5.1.0/24",<br>  "10.5.2.0/24"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the cluster | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br>  "customer": "k2view",<br>  "env": "rnd",<br>  "owner": "k2v-devops",<br>  "project": "dev",<br>  "terraform": "true"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR range of the network | `string` | `"10.5.0.0/16"` | no |
