module "vpc_cluster" {
  source              = "../modules/aws/network/vpc"
  vpc_name            = "${var.cluster_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  public_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
  tags                = var.tags
}

module "eks" {
  source                                    = "../modules/aws/k8s/eks"
  eks_cluster_name                          = var.cluster_name
  eks_cluster_version                       = var.kubernetes_version
  eks_cluster_endpoint_public_access        = var.eks_cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions  = var.enable_cluster_creator_admin_permissions
  vpc_id                                    = module.vpc_cluster.vpc_id
  subnet_ids                                = module.vpc_cluster.private_subnets
  control_plane_subnet_ids                  = module.vpc_cluster.public_subnets
  eks_instance_types                        = var.instance_types
  ami_type                                  = var.ami_type
  min_size                                  = var.eks_min_worker_count
  max_size                                  = var.eks_max_worker_count
  desired_size                              = var.desired_size
  capacity_type                             = var.capacity_type
  authentication_mode                       = var.authentication_mode
  tags                                      = var.tags

}



### DNS
module "dns-hosted-zone" {
  source       = "../modules/aws/dns/dns-hosted-zone"
  count        = var.domain != "" ? 1 : 0
  cluster_name = var.cluster_name
  domain       = var.domain
  common_tags  = var.tags
}

module "aws_load_balancer_controller" {
  source             = "../modules/aws/aws-load-balancer-controller"
  cluster_name       = module.eks.cluster_name
  region             = var.region
  vpc_id             = module.vpc_cluster.vpc_id
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.cluster_oidc_issuer_url
}

module "external_dns" {
  count             = var.domain != "" ? 1 : 0
  source            = "../modules/aws/external-dns"
  cluster_name      = var.cluster_name
  region            = var.region
  domain            = var.domain
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url
  txt_owner_id      = var.cluster_name
  zone_type         = "public"
}


data "aws_lbs" "alb" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.cluster_name
  }

  depends_on = [module.aws_load_balancer_controller]
}

data "aws_lb" "alb" {
  count      = length(data.aws_lbs.alb.arns) > 0 ? 1 : 0
  arn        = sort(data.aws_lbs.alb.arns)[0]
  depends_on = [data.aws_lbs.alb]
}

# DNS
module "dns-a-record" {
  depends_on   = [data.aws_lb.alb]
  source       = "../modules/aws/dns/dns-a-record"
  count        = var.domain != "" && length(data.aws_lbs.alb.arns) > 0 ? 1 : 0
  domain       = var.domain
  zone_id      = module.dns-hosted-zone[0].hz_zone_id
  nlb_dns_name = data.aws_lb.alb[0].dns_name
  nlb_zone_id  = data.aws_lb.alb[0].zone_id
}




### IRSA (deployer and space role)
module "irsa" {
  depends_on    = [module.eks]
  source        = "../modules/aws/irsa"
  aws_region    = var.region
  cluster_name  = var.cluster_name
  common_tags   = var.tags

  providers = {
    aws = aws
  }
}


# K2view Agent
module "k2view-agent" {
  depends_on               = [module.eks, module.irsa]
  count                    = var.mailbox_id != "" ? 1 : 0
  source                   = "../modules/shared/k2view-agent"
  mailbox_id               = var.mailbox_id
  mailbox_url              = var.mailbox_url
  region                   = var.region
  cloud_provider           = "AWS"
  namespace                = var.k2view_agent_namespace
  network_name             = module.vpc_cluster.vpc_id
  space_iam_arn            = module.irsa.iam_space_role_arn
  deployer_iam_arn         = module.irsa.iam_deployer_role_arn
  subnets                  = replace(join(",", module.vpc_cluster.private_subnets), ",", "\\,")
}


# Cluster autoscaler
module "cluster-autoscaler" {
  depends_on                    = [module.eks]
  count                         = var.deploy_autoscaler ? 1 : 0 
  source                        = "../modules/aws/k8s/autoscaler"
  cluster_name                  = var.cluster_name
  region                        = var.region
  role = module.eks.eks_managed_node_groups["main"].iam_role_name
}


### Storage Classes
module "ebs" {
  depends_on          = [module.eks]
  source              = "../modules/aws/k8s/storage-classes/ebs"
  encrypted           = true
  node_group_iam_role = module.eks.eks_managed_node_groups["main"].iam_role_name
  cluster_name        = var.cluster_name
}

#### EFS
module "efs" {
  depends_on          = [module.eks]
  source               = "../modules/aws/k8s/storage-classes/efs"
  cluster_name         = var.cluster_name
  aws_region           = var.region
  vpc_subnets          = module.vpc_cluster.private_subnets
  vpc_cidr             = var.vpc_cidr
  node_group_role_name = module.eks.eks_managed_node_groups.main.iam_role_name
  common_tags          = var.tags
  providers = {
    aws = aws
  }
}