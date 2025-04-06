module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name

  cidr = var.vpc_cidr

  azs                  = var.availability_zones
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  database_subnets     = var.database_subnets
  private_subnet_tags  = var.private_subnet_tags
  public_subnet_tags   = var.public_subnet_tags
  database_subnet_tags = var.database_subnet_tags
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = var.tags
}