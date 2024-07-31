output "iam_deployer_role_arn" {
  description = "The ARN of the IAM deployer role"
  value       = aws_iam_role.iam_deployer_role.arn
}
output "iam_space_role_arn" {
  description = "The ARN of the IAM deployer role"
  value       = aws_iam_role.iam_fabric_space_role.arn
}