module "vpc_cluster" {
  source              = "../modules/aws/network/vpc"
  vpc_name            = "${var.cluster_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
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

# Ingress Controller
module "ingress-controller" {
  depends_on              = [module.eks, module.dns-hosted-zone]
  source                  = "../modules/shared/ingress-controller"
  cloud_provider          = "aws"
  domain                  = var.domain
  aws_domain_cert_arn     = module.dns-hosted-zone[0].cert_arn
  vpc_cidr                = var.vpc_cidr
  enable_private_lb       = var.private_cluster
  default_ssl_certificate = false
  tls_enabled             = false
}

data "aws_lb" "nginx-nlb" {
  name       =  split("-", module.ingress-controller.lb_dns_name)[0] 
  depends_on = [module.ingress-controller]
}

# DNS
module "dns-a-record" {
  depends_on   = [data.aws_lb.nginx-nlb]
  source       = "../modules/aws/dns/dns-a-record"
  count        = var.domain != "" ? 1 : 0
  domain       = var.domain
  zone_id      = module.dns-hosted-zone[0].hz_zone_id
  nlb_dns_name = module.ingress-controller.lb_dns_name
  nlb_zone_id  = data.aws_lb.nginx-nlb.zone_id
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