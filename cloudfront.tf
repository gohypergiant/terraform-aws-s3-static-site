// Copyright 2020 Hypergiant, LLC

locals {
  custom_error_response = concat(
    var.enable_spa ? [
      {
        error_caching_min_ttl = var.min_ttl
        error_code            = 404
        response_code         = 200
        response_page_path    = "/${var.index_document}"
      }
    ] : [],
    var.custom_error_response,
    [      
      {
        error_caching_min_ttl = 0
        error_code            = 500
      },
      {
        error_caching_min_ttl = 0
        error_code            = 501
      },
      {
        error_caching_min_ttl = 0
        error_code            = 502
      },
      {
        error_caching_min_ttl = 0
        error_code            = 503
      },
      {
        error_caching_min_ttl = 0
        error_code            = 504
      },
    ]
  )
}

resource "aws_cloudfront_distribution" "this" {
  // checkov:skip=CKV_AWS_68:CloudFront Distribution should have WAF enabled
  origin {
    domain_name = aws_s3_bucket.this.website_endpoint
    origin_id   = aws_s3_bucket.this.bucket

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "Referer"
      value = random_uuid.referer.result
    }
  }

  dynamic "origin" {
    for_each = var.proxies

    content {
      domain_name = origin.value.destination.domain
      origin_path = origin.value.destination.path
      origin_id   = "${origin.value.destination.domain}-${origin.value.destination.path}"

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  # Base path proxy
  dynamic "ordered_cache_behavior" {
    for_each = var.proxies

    content {
      path_pattern     = ordered_cache_behavior.value.path
      target_origin_id = "${ordered_cache_behavior.value.destination.domain}-${ordered_cache_behavior.value.destination.path}"
      allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods   = ["HEAD", "GET", "OPTIONS"]
      forwarded_values {
        headers      = ["Accept", "Authorization"]
        query_string = true
        cookies {
          forward = "none"
        }
      }
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
      compress               = true
    }
  }
  # Additional wildcard for the proxy.
  dynamic "ordered_cache_behavior" {
    for_each = var.proxies

    content {
      path_pattern     = "${ordered_cache_behavior.value.path}/*"
      target_origin_id = "${ordered_cache_behavior.value.destination.domain}-${ordered_cache_behavior.value.destination.path}"
      allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods   = ["HEAD", "GET", "OPTIONS"]
      forwarded_values {
        headers      = ["Accept", "Authorization"]
        query_string = true
        cookies {
          forward = "none"
        }
      }
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
      compress               = true
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

  dynamic "custom_error_response" {
    for_each = local.custom_error_response

    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }
}
