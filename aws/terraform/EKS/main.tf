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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0"

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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 10
      desired_size = 2
    }
  }

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    aws-efs-csi-driver = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  tags = local.tags
}

module "efs" {
  source                  = "./modules/efs"
  cluster_name            = var.cluster_name
  aws_region              = var.aws_region
  owner                   = var.owner
  project                 = var.project
  env                     = var.env
  vpc_subnets             = module.vpc.public_subnets
  vpc_cidr                = local.vpc_cidr
  node_group_role_name    = module.eks.eks_managed_node_groups.initial.iam_role_name
    
  providers = {
    aws = aws
  }

  depends_on = [
    module.eks, module.vpc
  ]
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
  source                  = "./modules/Route53/create-a-record/"
  count                   = var.domain != "" ? 1 : 0
  domain                  = var.domain
  zone_id                 = module.subdomain-hz[0].hz_zone_id
  nlb_dns_name            = data.aws_lb.nginx-nlb.dns_name
  nlb_zone_id             = data.aws_lb.nginx-nlb.zone_id

  providers = {
    aws = aws
  }

  depends_on = [
    data.aws_lb.nginx-nlb,
  ]
}

module "irsa" {
  source                  = ".modules/irsa"
  aws_region              = var.aws_region
  cluster_name            = var.cluster_name
  owner                   = var.owner
  project                 = var.project
  env                     = var.env

  providers = {
    aws = aws
  }

  depends_on = [
    module.eks
  ]
}
