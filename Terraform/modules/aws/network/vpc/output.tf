output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "The public subnets"
}

output "private_subnets" {
  value = module.vpc.private_subnets
  description = "The private subnets"
}   

output "database_subnets" {
    value = module.vpc.database_subnets
  description = "The database subnets"

}

output "vpc_name" {
  value = module.vpc.name
  description = "The name of the VPC" 
}
