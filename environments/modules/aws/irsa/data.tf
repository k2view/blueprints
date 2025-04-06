data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "tls_certificate" "tls" {
  url = data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}