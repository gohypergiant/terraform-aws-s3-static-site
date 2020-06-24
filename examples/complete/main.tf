provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_route53_zone" "tools" {
  name = "example.com."
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "2.5.0"

  # ACM certs for Cloudfront must be created in us-east-1 so we do everything there.
  providers = {
    aws = aws.acm
  }

  domain_name          = "yoursite.example.com"
  zone_id              = data.aws_route53_zone.example.zone_id
  validate_certificate = true
  wait_for_validation  = true
  validation_method    = "DNS"
}

module "static-site" {
  source = "../../"

  # Certs for Cloudfront must be created in us-east-1 so we do everything there.
  providers = {
    aws = aws.acm
  }

  app_hostname = "yoursite.example.com"
  cnames       = ["yoursite.example.com"]
  // These create new buckets
  bucket_name          = "your-static-site-bucket-name"
  log_bucket_name      = "logging-bucket-name"
  log_prefix           = "web/"
  zone_id              = data.aws_route53_zone.example.zone_id
  service_account_name = "website-deployer" // this creates a new IAM user to use for CI/CD
  acm_certificate_arn  = module.acm.this_acm_certificate_arn
}

resource aws_iam_group "deployers" {
  name = "deployers"
}

resource "aws_iam_group_policy_attachment" "appcast-deployers" {
  group      = "deployers"
  policy_arn = module.static-site.iam_policy_arn
}
