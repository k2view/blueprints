output "efs_id" {
  value = aws_efs_file_system.EKS_EFS.id
}

output "efs_driver_SA_arn"{
  value = aws_iam_role.AmazonEKS_EFS_CSI_DriverRole.arn
}
