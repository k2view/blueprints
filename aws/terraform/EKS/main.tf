### Data Sources
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia # The ECR roken only works for virginia
}

### VPC
locals {
  azs = [for zone in var.zones : "${var.region}${zone}"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.network_name != "" ? var.network_name : "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1 # Tag for external LoadBalancer
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1 # tag for internal LoadBalancer
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = var.cluster_name
  }

  tags = var.tags
}

### EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      addon_version = "v1.31.0-eksbuild.1"
    },
    aws-efs-csi-driver = {
      addon_version = "v2.0.3-eksbuild.1"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    karpenter = {
      min_size     = var.min_node
      max_size     = var.max_node
      desired_size = var.desired_size

      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"

      taints = {
        # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
        # The pods that do not tolerate this taint should run on nodes created by Karpenter
        addons = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "PREFER_NO_SCHEDULE"
        },
    }
  }
  }

  node_security_group_tags = merge(var.tags, {
  "karpenter.sh/discovery" = var.cluster_name
  })

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = var.tags
}


resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.2-eksbuild.2"
}

### Karpenter

# create the IAM roles for karpenter
module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.24.0" 

  cluster_name = module.eks.cluster_name

  enable_v1_permissions           = true
  enable_pod_identity             = true
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}

resource "helm_release" "karpenter" {
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.0.0"
  wait                = false

  values = [
    <<-EOT
    serviceAccount:
      name: ${module.karpenter.service_account}
    settings:
      clusterName: ${module.eks.cluster_name}
      interruptionQueue: ${module.karpenter.queue_name}
    EOT
  ]

}


resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2023
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]

}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          nodeClassRef:
            name: default
          requirements:
            - key: node.kubernetes.io/instance-type
              operator: In
              values:
              - ${join("\n - ", var.instance_types)}
            - key: karpenter.sh/capacity-type
              operator: In
              values:
              - on-demand
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 60s
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]

}

### DNS + Ingress
module "dns-hosted-zone" {
  source       = "./modules/dns/dns-hosted-zone"
  count        = var.domain != "" ? 1 : 0
  cluster_name = var.cluster_name
  domain       = var.domain
  common_tags  = var.tags
}

module "ingress" {
  depends_on        = [module.eks]
  source            = "./modules/ingress"
  domain            = var.domain
  aws_cert_arn      = module.dns-hosted-zone[0].cert_arn
  aws_vpc_cidr      = var.vpc_cidr
  enable_private_lb = false
}

data "kubernetes_service" "nginx_lb" {
  depends_on = [module.ingress]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "aws_lb" "nginx-nlb" {
  name       = regex("^(?P<name>.+)-.+\\.elb\\..+\\.amazonaws\\.com", data.kubernetes_service.nginx_lb.status.0.load_balancer.0.ingress.0.hostname)["name"]
  depends_on = [data.kubernetes_service.nginx_lb]
}

module "dns-a-record" {
  source       = "./modules/dns/dns-a-record"
  count        = var.domain != "" ? 1 : 0
  domain       = var.domain
  zone_id      = module.dns-hosted-zone[0].hz_zone_id
  nlb_dns_name = data.aws_lb.nginx-nlb.dns_name
  nlb_zone_id  = data.aws_lb.nginx-nlb.zone_id

  depends_on = [
    data.aws_lb.nginx-nlb,
  ]
}

### Grafana Agent
module "grafana_agent" {
  depends_on                                     = [module.eks]
  count                                          = var.deploy_grafana_agent ? 1 : 0
  source                                         = "./modules/grafana-agent"
  cluster_name                                   = var.cluster_name
  externalservices_prometheus_basicauth_password = var.grafana_token
  externalservices_loki_basicauth_password       = var.grafana_token
  externalservices_tempo_basicauth_password      = var.grafana_token

}

### K2V Agent
module "k2v_agent" {
  depends_on       = [module.eks]
  count            = var.mailbox_id != "" ? 1 : 0
  source           = "./modules/k2v_agent"
  mailbox_id       = var.mailbox_id
  mailbox_url      = var.mailbox_url
  cloud_provider   = "AWS"
  region           = var.region
  space_iam_arn    = module.irsa.iam_space_role_arn
  deployer_iam_arn = module.irsa.iam_deployer_role_arn
  network_name     = module.vpc.vpc_id
  subnets          = replace(join(",", module.vpc.private_subnets), ",", "\\,")

}

### Storage Classes
module "ebs" {
  depends_on          = [module.eks]
  source              = "./modules/storage-classes/ebs"
  encrypted           = true
  node_group_iam_role = module.eks.eks_managed_node_groups["karpenter"].iam_role_name
}

#### EFS
module "efs" {
  count                = var.efs_enabled ? 1 : 0
  source               = "./modules/storage-classes/efs"
  cluster_name         = var.cluster_name
  aws_region           = var.region
  vpc_subnets          = module.vpc.private_subnets
  vpc_cidr             = var.vpc_cidr
  node_group_role_name = module.eks.eks_managed_node_groups.initial.iam_role_name
  common_tags          = var.tags

  providers = {
    aws = aws
  }

}

### IRSA (deployer and space role)
module "irsa" {
  source       = "./modules/irsa"
  aws_region   = var.region
  cluster_name = var.cluster_name
  common_tags  = var.tags

  providers = {
    aws = aws
  }

  depends_on = [
    module.eks
  ]
}

### Metrics server
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  depends_on = [module.eks]
  namespace  = "kube-system"

  # Recent updates to the Metrics Server do not work with self-signed certificates by default.
  # Since Docker For Desktop uses such certificates, you’ll need to allow insecure TLS
  set {
    name  = "args"
    value = "{--kubelet-insecure-tls=true}"
  }

  # Wait for the release to be deployed
  wait = true

}