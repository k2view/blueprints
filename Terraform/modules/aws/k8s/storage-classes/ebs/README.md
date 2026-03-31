# AWS EBS Storage Class Module
Creates an IAM policy for the EBS CSI driver, attaches it to the node group role, and deploys an encrypted EBS storage class via Helm.

## Usage
```hcl
module "ebs" {
  source = "./modules/aws/k8s/storage-classes/ebs"

  cluster_name        = "my-eks-cluster"
  node_group_iam_role = module.eks.node_group_role_arn
  encrypted           = true
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
| [aws_iam_policy.ebs_csi_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.attach_ebs_csi_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.ebs_storage_class](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_role.node_group_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | EKS cluster name | `string` | n/a | yes |
| node_group_iam_role | IAM role name of the EKS node group | `string` | n/a | yes |
| encrypted | Whether to encrypt EBS volumes | `bool` | `true` | no |
