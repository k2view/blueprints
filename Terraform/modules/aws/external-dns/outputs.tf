output "role_arn" {
  description = "IAM role ARN used by ExternalDNS"
  value       = aws_iam_role.external_dns.arn
}

output "helm_release_name" {
  description = "Helm release name for ExternalDNS"
  value       = helm_release.external_dns.name
}
