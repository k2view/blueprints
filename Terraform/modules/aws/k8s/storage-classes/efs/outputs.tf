output "efs_id" {
  value       = aws_efs_file_system.EKS_EFS.id
  description = "Resource ID of the EFS file system"
}

output "efs_driver_SA_arn" {
  value       = aws_iam_role.AmazonEKS_EFS_CSI_DriverRole.arn
  description = "ARN of the EFS CSI driver IAM role"
}
