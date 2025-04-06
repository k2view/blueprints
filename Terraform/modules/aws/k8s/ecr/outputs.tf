
output "repository_url" {
  value = module.ecr.repository_url
  description = "The URL of the ECR repository"
}


output "repository_arn" {
  value = module.ecr.repository_arn
  description = "The ARN of the ECR repository"
}

output "repository_name" {
  value = module.ecr.repository_name
  description = "The name of the ECR repository"
}

output "repository_registry_id" {
  value = module.ecr.repository_registry_id
  description = "The registry ID of the ECR repository"
}

