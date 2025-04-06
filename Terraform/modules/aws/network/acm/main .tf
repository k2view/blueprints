# Define a module named "acm" using the AWS ACM Terraform module
# This configuration creates an SSL/TLS certificate using AWS Certificate Manager for the domain "my-domain.com" and its subdomains.
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  # Set the primary domain name for the SSL/TLS certificate
  domain_name  = "my-domain.com"
  zone_id      = "Z2ES7B9AZ6SHAE"

  validation_method = "DNS"

  # Define additional domain names (subdomains) to be included in the certificate
  subject_alternative_names = [
    "*.my-domain.com",   # Wildcard subdomain
    "app.sub.my-domain.com",  # Specific subdomain
  ]

  wait_for_validation = true

  tags = {
    Name = "my-domain.com"
  }
}