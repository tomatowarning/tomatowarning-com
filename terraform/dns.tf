resource "aws_route53_zone" "public" {
  name    = local.app_domain
  comment = "ZBMowrey.com Website & Resources - Managed by Terraform"
}

resource "aws_route53_record" "root" {
  name    = local.app_domain
  type    = "A"
  zone_id = aws_route53_zone.public.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.web-dist.domain_name
    zone_id                = aws_cloudfront_distribution.web-dist.hosted_zone_id
  }
}

resource "aws_route53_record" "mx" {
  for_each = length(var.mx_records) > 0 ? var.mx_records : tomap({})
  name     = each.key
  type     = "MX"
  ttl      = 60
  zone_id  = aws_route53_zone.public.zone_id
  records  = each.value
}

resource "aws_route53_record" "cname" {
  for_each = length(var.cname_records) > 0 ? var.cname_records : tomap({})
  name     = each.key
  type     = "CNAME"
  ttl      = 60
  zone_id  = aws_route53_zone.public.zone_id
  records  = [each.value]
}

resource "aws_route53_record" "txt" {
  for_each = length(var.txt_records) > 0 ? var.txt_records : tomap({})
  name     = each.key
  type     = "TXT"
  ttl      = 60
  zone_id  = aws_route53_zone.public.zone_id
  records  = each.value
}

resource "aws_route53_record" "ns" {
  for_each = length(var.ns_records) > 0? var.ns_records : tomap({})
  name     = each.key
  type     = "NS"
  ttl      = 60
  zone_id  = aws_route53_zone.public.zone_id
  records  = each.value
}