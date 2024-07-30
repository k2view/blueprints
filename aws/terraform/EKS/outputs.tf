output "cluster_iam_role_name" {
  value       = module.eks.cluster_iam_role_name
  description = "The name of the cluster IAM role"
}

output "node_group_role_name" {
  value = module.eks.eks_managed_node_groups["initial"].iam_role_name
}