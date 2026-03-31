# AWS DNS A Record Module
Creates two Route 53 A records (alias) pointing to a Network Load Balancer: one for the exact domain and one wildcard (`*.domain`).

## Usage
```hcl
module "dns-a-record" {
  source = "./modules/aws/dns/dns-a-record"

  domain       = "k2view.example.com"
  zone_id      = module.dns-hosted-zone.hz_zone_id
  nlb_dns_name = module.ingress-controller.lb_dns_name
  nlb_zone_id  = data.aws_lb.nginx-nlb.zone_id
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
| [aws_route53_record.record_to_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record_to_nlb_wildCard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain | Domain name for the Route 53 A record | `string` | n/a | yes |
| zone_id | Route 53 hosted zone ID where the records will be created | `string` | n/a | yes |
| nlb_dns_name | DNS name of the Network Load Balancer to alias | `string` | n/a | yes |
| nlb_zone_id | Hosted zone ID of the Network Load Balancer (used for alias routing) | `string` | n/a | yes |
