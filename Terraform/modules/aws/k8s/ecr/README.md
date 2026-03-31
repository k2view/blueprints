# AWS ECR Module
Creates an ECR repository using the `terraform-aws-modules/ecr/aws` module with a lifecycle policy that retains up to 300,000 tagged images.

## Usage
```hcl
module "ecr" {
  source = "./modules/aws/k8s/ecr"

  repository_name                   = "my-app"
  repository_read_write_access_arns = [module.irsa.iam_deployer_role_arn]
  tags = {
    Env = "prod"
  }
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| [ecr](https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest) | terraform-aws-modules/ecr/aws | n/a |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_name | ECR repository name | `string` | n/a | yes |
| repository_read_write_access_arns | IAM ARNs granted read/write access to the repository | `list(string)` | n/a | yes |
| tags | Tags to apply to the repository | `map(string)` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| repository_url | ECR repository URL |
| repository_arn | ECR repository ARN |
| repository_name | ECR repository name |
| repository_registry_id | ECR registry ID |
