data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "kubernetes_service" "nginx-ingress" {
  metadata {
    namespace = "ingress-nginx"
    name = "ingress-nginx-controller"
  }

  depends_on = [resource.helm_release.defaults]
}

data "aws_lb" "nginx-nlb" {
  name = regex("^(?P<name>.+)-.+\\.elb\\..+\\.amazonaws\\.com", data.kubernetes_service.nginx-ingress.status.0.load_balancer.0.ingress.0.hostname)["name"]
  depends_on = [data.kubernetes_service.nginx-ingress]
}

locals {
  region = var.aws_region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Owner = var.owner
    Project = var.project
    Env = var.env
  }
}

################################################################################
# Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.2xlarge"]

      min_size     = 1
      max_size     = 10
      desired_size = 2
    }
  }

  tags = local.tags
}

#---------------------------------------------------------------
# Supporting Resources
#---------------------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.cluster_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}


module "subdomain-hz" {
  source                  = "./modules/Route53/subdomain-hz/"
  count                   = var.domain != "" ? 1 : 0
  cluster_name            = var.cluster_name
  domain                  = var.domain
  owner                   = var.owner
  project                 = var.project
  env                     = var.env
    
  providers = {
    aws = aws
  }
}

module "create-a-record" {
  source                      = "./modules/Route53/create-a-record/"
  count                       = var.domain != "" ? 1 : 0
  domain                      = var.domain
  zone_id                     = module.subdomain-hz[0].hz_zone_id
  nlb_dns_name                = data.aws_lb.nginx-nlb.dns_name
  nlb_zone_id                 = data.aws_lb.nginx-nlb.zone_id

  providers = {
    aws = aws
  }

  depends_on = [
    data.aws_lb.nginx-nlb,
  ]
}

#---------------------------------------------------------------
# K8s Defaultly needed applications per K2view's Specification
#---------------------------------------------------------------

    # Karpenter IAM Needed Resources

resource "aws_cloudformation_stack" "karpenter" {
  name = "Karpenter-${var.cluster_name}" 
  template_body = file("${var.karpenter_cloudformation_path}")

  capabilities = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    ClusterName = var.cluster_name
  }
}


    # Create the IAM Role for Karpenter

resource "aws_iam_role" "karpenter_node_role" {
  name = "${var.cluster_name}-karpenter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "${module.eks.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:karpenter:karpenter"
          }
        }
      }
    ]
  })
}

#     # IAM role (instance porfile) to inhert certian AWS Policies to Ensure STS assume role and others for karpenter

# resource "aws_iam_role" "instance_profile_role" {
#   name = "KarpenterNodeRole-${var.cluster_name}"
#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Service": "ec2.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_instance_profile" "instance_profile" {
#   name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
#   role = aws_iam_role.instance_profile_role.name
# }

#     # Attach necessary policies to the IAM Role

#         # IAM Role (Instance Profile Policies)

# resource "aws_iam_role_policy_attachment" "ecr_readonly_attachment" {
#   policy_arn = data.aws_iam_policy.ecr_readonly.arn
#   role       = aws_iam_role.instance_profile_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_attachment" {
#   policy_arn = data.aws_iam_policy.eks_cni.arn
#   role       = aws_iam_role.instance_profile_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_worker_node_attachment" {
#   policy_arn = data.aws_iam_policy.eks_worker_node.arn
#   role       = aws_iam_role.instance_profile_role.name
# }

# resource "aws_iam_role_policy_attachment" "ssm_managed_instance_attachment" {
#   policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
#   role       = aws_iam_role.instance_profile_role.name
# }


        # Karpenter IAM Role - policy create in above Cloud formation.


resource "aws_iam_role_policy_attachment" "karpenter_controller_policy" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
  role       = aws_iam_role.karpenter_node_role.name

  depends_on = [aws_cloudformation_stack.karpenter]
}


    # END Karpenter IAM Needed Resources END

resource "helm_release" "defaults" {
  name      = "k2-defaults"
  chart      = "./Helm/k2-defaults"

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
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-shaditest42"
  }

  set {
    name  = "karpenter.karpenter.settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "karpenter.karpenter.settings.aws.defaultInstanceProfile"
    value = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  }

  set {
    name  = "karpenter.karpenter.settings.aws.interruptionQueueName"
    value = var.cluster_name
  }

  depends_on = [
    aws_cloudformation_stack.karpenter,
    module.eks
  ]
}