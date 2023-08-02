resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  namespace        = "external-secrets"
  create_namespace = true
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  chart      = "oci://public.ecr.aws/karpenter/karpenter"
  version    = var.karpenter_version
  namespace  = "karpenter"
  create_namespace = true

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_node_role.arn
  }

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = var.cluster_name
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "1"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "1"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "1Gi"
  }

  wait = true
}

resource "helm_release" "k2view" {
  name      = "k2view"
  chart      = "./Helm/k2-defaults"

  timeout = 100

  # Global values
  set {
    name  = "global.clusterName"
    value = var.cluster_name
  }

  # Nginx-Ingress
  set {
    name  = "nginx-ingress.awsDomainCert"
    value = module.subdomain-hz[0].cert_arn
  }
  
  set {
    name  = "nginx-ingress.domainName"
    value = var.domain
  }

  # Karpenter

  set {
    name  = "karpenter.instanceProfileARN"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
  }

  depends_on = [
    aws_cloudformation_stack.karpenter,
    module.eks,
    helm_release.external_secrets
  ]
}