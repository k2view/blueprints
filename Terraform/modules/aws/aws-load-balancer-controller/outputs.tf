output "controller_role_arn" {
  description = "ARN of the IAM role used by the AWS Load Balancer Controller"
  value       = aws_iam_role.controller.arn
}

output "helm_release_name" {
  description = "Helm release name for the AWS Load Balancer Controller"
  value       = helm_release.controller.name
}
