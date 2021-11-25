
# We're going to create a multi-bucket static site in separate regions
# to provide high availability in case of regional failure.

locals {
  web_primary_bucket   = join("-", [var.app_name, var.environment, var.web_primary_bucket])
  web_secondary_bucket = join("-", [var.app_name, var.environment, var.web_secondary_bucket])
  web_log_bucket       = join("-", [var.app_name, var.environment, var.web_log_bucket])
  app_domain           = var.environment == "main" ? var.root_domain : join(".", [var.environment, var.root_domain])
  api_domain           = "api.${local.app_domain}"
  acm_validations      = []
  default_tags         = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = var.environment
      Terraform   = true
  }
}
resource "aws_s3_bucket" "web-primary" {
  provider = aws.primary
  bucket   = local.web_primary_bucket
  acl      = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "PublicRead"
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject", "s3:GetObjectVersion"]
      Resource = ["arn:aws:s3:::${local.web_primary_bucket}/*"]
    }]
  })
}

# Secondary is us-east-1 (Virginia) - this is our failover origin

resource "aws_s3_bucket" "web-secondary" {
  provider = aws.secondary
  bucket   = local.web_secondary_bucket
  acl      = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "PublicRead"
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject", "s3:GetObjectVersion"]
      Resource = ["arn:aws:s3:::${local.web_secondary_bucket}/*"]
    }]
  })
}

resource "aws_s3_bucket" "web-logs" {
  provider = aws.secondary # logs should be written to us-east-1
  bucket   = local.web_log_bucket
  lifecycle_rule {
    id      = "rotating-logs"
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 60
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "web-oai" {
  provider = aws.primary
  comment  = "Managed by ${var.app_name}-${var.environment} terraform (test)"
}

resource "aws_cloudfront_distribution" "web-dist" {
  depends_on          = [aws_acm_certificate.web-cert]
  provider            = aws.primary
  price_class         = "PriceClass_100"
  enabled             = true
  default_root_object = "index.html"

  aliases = [local.app_domain, join(".", ["www", local.app_domain])]

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 30
  }
  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 30
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = "groupS3"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  origin_group {
    origin_id = "groupS3"
    failover_criteria {
      status_codes = [500, 502]
    }
    member {
      origin_id = "primaryS3"
    }
    member {
      origin_id = "failoverS3"
    }
  }
  origin {
    domain_name = aws_s3_bucket.web-primary.bucket_regional_domain_name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.web-secondary.bucket_regional_domain_name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-oai.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.web-cert.arn
    ssl_support_method             = "sni-only"
  }
  tags = {
    Description = "${var.app_name}-${var.environment}"
  }
}

resource "aws_acm_certificate" "web-cert" {
  provider                  = aws.secondary
  domain_name               = local.app_domain
  subject_alternative_names = [join(".", ["*", local.app_domain])]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.app_name} - ${var.environment}"
  }
}

resource "aws_route53_record" "root-acm" {
  for_each = {
    for option in aws_acm_certificate.web-cert.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.public.zone_id
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn         = aws_acm_certificate.web-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.root-acm : record.fqdn]
}