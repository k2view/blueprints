# Creating needed IAM Policy
resource "aws_iam_policy" "AmazonEKS_EFS_CSI_Driver_Policy" {
  name        = "${var.cluster_name}_AmazonEKS_EFS_CSI_Driver_Policy"
  path        = "/"
  description = "EFS EKS Specifc Role Policy"

  policy      = file("${path.module}/iam_policies/iam_efs_driver_policy.json")
}

# Creating EFS Driver Role
resource "aws_iam_role" "AmazonEKS_EFS_CSI_DriverRole" {
  name = "${var.cluster_name}_AmazonEKS_EFS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.example.identity[0].oidc[0].issuer)[0]}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
          "oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.example.identity[0].oidc[0].issuer)[0]}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      }
    ]
    })

  tags = {
    Name    = "${var.cluster_name}_AmazonEKS_EFS_CSI_DriverRole"
    Env     = var.env
    Owner   = var.owner
    Project = var.project
  }
}

# Attaching Role Policy
resource "aws_iam_role_policy_attachment" "AmazonEKS_EFS_CSI_DriverRole_policy_attachment" {
  role       = aws_iam_role.AmazonEKS_EFS_CSI_DriverRole.name
  policy_arn = aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy.arn
}

# Attaching Policy to EKS node group role
resource "aws_iam_role_policy_attachment" "AmazonEKS_EFS_CSI_DriverRole_policy_attachment_to_nodegroup" {
  role       = var.node_group_role_name
  policy_arn = aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy.arn
}

# Creating EFS Related Security group and allowing traffic from EKS CIDR
resource "aws_security_group" "EfsSecurityGroup" {
  name        = "${var.cluster_name}_EfsSecurityGroup "
  description = "Allows traffic from EKS"
  vpc_id      = data.aws_eks_cluster.example.vpc_config[0].vpc_id

  ingress {
    description      = "allow from EKS"
    from_port        = 2049 
    to_port          = 2049 
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  tags = {
    Name    = "${var.cluster_name}_EfsSecurityGroup"
    Env     = var.env
    Owner   = var.owner
    Project = var.project
  }
}

# Creating EFS FileSystem
resource "aws_efs_file_system" "EKS_EFS" {
  tags = {
    Name    = "${var.cluster_name}_EFS"
    Env     = var.env
    Owner   = var.owner
    Project = var.project
  }
}

# Adding Mount Targets per Subnet of related EKS VPC
resource "aws_efs_mount_target" "mount_targets" {
  count           = length(var.vpc_subnets)

  file_system_id  = aws_efs_file_system.EKS_EFS.id
  subnet_id       = "${var.vpc_subnets[count.index]}"
  security_groups = [aws_security_group.EfsSecurityGroup.id]
}
