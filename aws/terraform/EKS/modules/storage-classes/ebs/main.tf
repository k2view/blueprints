resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "Policy to allow EKS nodes to use the EBS CSI driver"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:ModifyVolume",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })
}

data "aws_iam_role" "node_group_role" {
  name = var.node_group_iam_role
}

resource "aws_iam_role_policy_attachment" "attach_ebs_csi_policy" {
  policy_arn = aws_iam_policy.ebs_csi_policy.arn
  role       = data.aws_iam_role.node_group_role.name
}

resource "helm_release" "ebs_storage_class" {
  name    = "ebs-storage-class"
  chart   = "helm/storage-classes/ebs"

  set {
    name  = "encrypted"
    value = true
  }
}
