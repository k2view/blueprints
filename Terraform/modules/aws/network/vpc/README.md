# AWS VPC Module
Creates an AWS VPC with public, private, and database subnets across multiple availability zones using the `terraform-aws-modules/vpc/aws` module.

## Usage
```hcl
module "vpc" {
  source = "./modules/aws/network/vpc"

  vpc_name           = "my-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Modules
| Name | Source | Version |
|------|--------|---------|
| [vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) | terraform-aws-modules/vpc/aws | n/a |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | VPC name | `string` | `""` | no |
| vpc_cidr | VPC CIDR block | `string` | `""` | no |
| availability_zones | List of availability zones for subnets | `list(string)` | `[]` | no |
| private_subnets | CIDR blocks for private subnets | `list(string)` | `[]` | no |
| public_subnets | CIDR blocks for public subnets | `list(string)` | `[]` | no |
| database_subnets | CIDR blocks for database subnets | `list(string)` | `[]` | no |
| enable_nat_gateway | Whether to create a NAT gateway for private subnet outbound traffic | `bool` | `true` | no |
| enable_vpn_gateway | Whether to create a VPN gateway | `bool` | `false` | no |
| enable_dns_hostnames | Whether to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Whether to enable DNS support in the VPC | `bool` | `true` | no |
| tags | Tags to apply to all resources | `map(any)` | `{...}` | no |
| private_subnet_tags | Additional tags for private subnets | `map(any)` | `{...}` | no |
| public_subnet_tags | Additional tags for public subnets | `map(any)` | `{...}` | no |
| database_subnet_tags | Additional tags for database subnets | `map(any)` | `{...}` | no |

## Outputs
| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_name | VPC name |
| public_subnets | List of public subnet IDs |
| private_subnets | List of private subnet IDs |
| database_subnets | List of database subnet IDs |
