# AWS DNS Hosted Zone Module
Creates a Route 53 public hosted zone and an ACM certificate (with DNS validation) for the given domain. Optionally adds NS records to the parent hosted zone to complete subdomain delegation.

## Usage
```hcl
module "dns-hosted-zone" {
  source       = "./modules/aws/dns/dns-hosted-zone"

  cluster_name = "my-eks-cluster"
  domain       = "k2view.example.com"

  create_parent_zone_records = true  # adds NS records to example.com hosted zone
}
```

## Requirements
| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Providers
| Name | Version |
|------|---------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 5.0 |

## Resources
| Name | Type |
|------|------|
| [aws_route53_zone.cluster_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_route53_record.cret_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.parent_hz_ns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.parent_hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | EKS cluster name (used for resource naming) | `string` | n/a | yes |
| domain | Domain name for the Route 53 hosted zone and ACM certificate | `string` | n/a | yes |
| create_parent_zone_records | Whether to create NS records in the parent hosted zone | `bool` | `false` | no |
| common_tags | Tags to apply to all resources | `map(string)` | `{...}` | no |

## Outputs
| Name | Description |
|------|-------------|
| hz_zone_id | Route 53 hosted zone ID |
| cert_arn | ACM certificate ARN |
