module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = var.repository_name

  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 300000 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 300000
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}