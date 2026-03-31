# AWS Cluster Autoscaler Module
Deploys the Kubernetes Cluster Autoscaler via Helm and creates the required IAM policy, attaching it to the specified node group IAM role.

## Usage
```hcl
module "cluster-autoscaler" {
  source = "./modules/aws/k8s/autoscaler"

  cluster_name = var.cluster_name
  region       = var.region
  role         = module.eks.eks_managed_node_groups["main"].iam_role_name
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0 |
| helm | >= 2.0 |

## Providers
| Name | Version |
|------|---------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 5.0 |
| [helm](https://registry.terraform.io/providers/hashicorp/helm/latest) | >= 2.0 |

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
| cluster_name | EKS cluster name | `string` | n/a | yes |
| region | AWS region where the EKS cluster is deployed | `string` | n/a | yes |
| role | IAM role name to attach the cluster autoscaler policy to | `string` | n/a | yes |
