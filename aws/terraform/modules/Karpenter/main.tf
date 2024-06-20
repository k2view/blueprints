# Karpenter IAM Needed Resources
resource "aws_cloudformation_stack" "karpenter" {
  name = "Karpenter-${var.cluster_name}" 
  template_body = file("${var.karpenter_cloudformation_path}")

  capabilities = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    ClusterName = var.cluster_name
  }
}

# IAM Role for Karpenter
resource "aws_iam_role" "karpenter_node_role" {
  name = "${var.cluster_name}-karpenter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
            "${var.oidc_provider}:sub" = "system:serviceaccount:karpenter:karpenter"
          }
        }
      }
    ]
  })
}

# Attach Policy Created using CloudFormation
resource "aws_iam_role_policy_attachment" "karpenter_controller_policy" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
  role       = aws_iam_role.karpenter_node_role.name

  depends_on = [aws_cloudformation_stack.karpenter]
}