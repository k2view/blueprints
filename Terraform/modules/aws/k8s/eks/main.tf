module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = var.eks_cluster_name
  cluster_version                 = var.eks_cluster_version

  cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access 

  cluster_addons                  = var.cluster_addons

  vpc_id                          = var.vpc_id 
  subnet_ids                      = var.subnet_ids 
  control_plane_subnet_ids        = var.control_plane_subnet_ids

  # EKS Managed Node Group(s) defaults
  eks_managed_node_group_defaults = {
    instance_types                = var.eks_instance_types
    disk_size                     = var.disk_size
    disk_type                     = var.disk_type
    disk_iops                     = var.disk_iops
    disk_throughput               = var.disk_throughput
    disk_encryption_enabled       = var.disk_encryption_enabled
    disk_encryption_kms_key_arn   = var.custom_kms_key_arn != null ? var.custom_kms_key_arn : null
    tags                          = var.tags
  }

  eks_managed_node_groups         = {
    main = {
      name                        = "${var.eks_cluster_name}-main"
      ami_type                    = var.ami_type
      instance_types              = var.eks_instance_types

      min_size                    = var.min_size
      max_size                    = var.max_size
      desired_size                = var.desired_size
      capacity_type               = var.capacity_type
      tags                        = var.tags
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  # This is a new parameter in version 20 and is correctly used
  authentication_mode = var.authentication_mode

  # This block is correct and supported in version 20
  access_entries = var.access_entries

  enable_irsa = true

  tags = var.tags
}
