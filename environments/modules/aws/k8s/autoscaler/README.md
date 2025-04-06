<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |


## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.kubernetes_cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.kubernetes_cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.kubernetes_cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | The IAM role name for the cluster autoscaler | `string` | n/a | yes |
| <a name="input_deploy_autoscaler"></a> [deploy\_autoscaler](#input\_deploy\_autoscaler) | Whether to deploy the cluster autoscaler | `bool` | `true` | no |


## Usage

To use the `cluster-autoscaler` module within a parent module, include the following configuration:

```hcl
module "cluster-autoscaler" {
  depends_on                    = [module.eks]
  count                         = var.deploy_autoscaler ? 1 : 0 
  source                        = "../../../modules/aws/k8s/autoscaler"
  cluster_name                  = var.cluster_name
  region                        = var.region
  role                          = module.eks.eks_managed_node_groups["main"].iam_role_name
}
```
<!-- END_TF_DOCS -->