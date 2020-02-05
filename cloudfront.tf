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

  aliases = [var.app_hostname]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront Distribution for ${var.app_hostname}"
  default_root_object = "index.html"

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

  viewer_certificate {
    acm_certificate_arn = module.acm.this_acm_certificate_arn
  }

  tags {
    Name = var.app_hostname
  }
}
