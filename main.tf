resource "random_id" "iam" {
  byte_length = 2
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.app_hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}
