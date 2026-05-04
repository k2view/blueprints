locals {
  helm_values = {
    clusterName  = var.cluster_name
    region       = var.region
    vpcId        = var.vpc_id
    replicaCount = 2
    ingressClass               = "alb"  ## default is alb
    createIngressClassResource = true  ## default is true
    ingressClassConfig = {
      default = true
    }
    serviceAccount = {
      create = true
      name   = "aws-load-balancer-controller"
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.controller.arn
      }
    }
  }
}

resource "helm_release" "controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version
  namespace  = "kube-system"

  values = [yamlencode(local.helm_values)]
}
