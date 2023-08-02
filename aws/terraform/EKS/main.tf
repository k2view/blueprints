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
# K8s Cluster
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


    # IAM Role for Karpenter

resource "aws_iam_role" "karpenter_node_role" {
  name = "${var.cluster_name}-karpenter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"
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

    # Attach Policy Created using CloudFormation

resource "aws_iam_role_policy_attachment" "karpenter_controller_policy" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
  role       = aws_iam_role.karpenter_node_role.name

  depends_on = [aws_cloudformation_stack.karpenter]
}