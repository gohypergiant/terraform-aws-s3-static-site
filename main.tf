resource "random_id" "iam" {
  byte_length = 2
}

resource "aws_s3_bucket" "this" {
  // checkov:skip=CKV_AWS_19: Do not encrypt public buckets
  // checkov:skip=CKV_AWS_20: Public bucket should have public-read
  // checkov:skip=CKV_AWS_52: AWS+TF do not properly support mfa_delete
  bucket = var.bucket_name
  acl    = "public-read"

  versioning {
    enabled = var.bucket_versioning
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "${var.log_prefix}/s3"
  }

}

resource "aws_s3_bucket" "logs" {
  bucket = var.log_bucket_name
  acl    = "log-delivery-write"
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
