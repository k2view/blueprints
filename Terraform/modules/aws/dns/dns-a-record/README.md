<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.record_to_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record_to_nlb_wildCard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain for rout53. | `string` | n/a | yes |
| <a name="input_nlb_dns_name"></a> [nlb\_dns\_name](#input\_nlb\_dns\_name) | nlb dns name. | `string` | n/a | yes |
| <a name="input_nlb_zone_id"></a> [nlb\_zone_id](#input\_nlb\_zone_id) | hosted zone id to create a record on | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone_id) | hosted zone id to create a record on | `string` | n/a | yes |

## Usage

To use the `dns-a-record` module within a parent module, include the following configuration:

```hcl
module "dns-a-record" {
  depends_on   = [data.aws_lb.nginx-nlb]
  source       = "../../../modules/aws/dns/dns-a-record"
  count        = var.domain != "" ? 1 : 0
  domain       = var.domain
  zone_id      = module.dns-hosted-zone[0].hz_zone_id
  nlb_dns_name = module.ingress-controller.lb_dns_name
  nlb_zone_id  = data.aws_lb.nginx-nlb.zone_id
}
```
Make sure to replace the source path with the correct relative path to the dns-a-record module and provide the necessary variables (domain, zone_id, nlb_dns_name, and nlb_zone_id).
<!-- END_TF_DOCS -->