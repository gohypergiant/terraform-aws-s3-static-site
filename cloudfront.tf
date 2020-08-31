// Copyright 2020 Hypergiant, LLC

locals {
  spa_custom_error_response = [
    {
      error_caching_min_ttl = var.min_ttl
      error_code            = 404
      response_code         = 200
      response_page_path    = var.index_document
    }
  ]
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Origin Access Identity for ${var.app_hostname}"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  aliases = var.cnames

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront Distribution for ${var.app_hostname}"
  default_root_object = var.index_document

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = "${var.log_prefix}/cloudfront/"
  }


  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = aws_s3_bucket.this.bucket

    forwarded_values {
      query_string = var.forward_query_string

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response = concat(
    var.enable_spa ? locals.spa_custom_error_response : [],
    var.custom_error_response
  )
}
