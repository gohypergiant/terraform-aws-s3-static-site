// Copyright 2020 Hypergiant, LLC

variable "bucket_name" {
  type        = string
  description = "Name of bucket for static site"
}

variable "log_bucket_name" {
  type        = string
  description = "Name of S3 bucket to create for storing logs"
}

variable "log_prefix" {
  type        = string
  description = "Prefix to use for S3 bucket logging."
}

variable "index_document" {
  type        = string
  description = "Index document for static site"
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "Error document for static site"
  default     = "error.html"
}

variable "enable_spa" {
  type        = bool
  description = "Enable SPA error handler. Disable for true multi-page behavior"
  default     = true
}

variable "custom_error_response" {
  type = list(object({
    error_caching_min_ttl = number
    error_code            = number
    response_code         = number
    response_page_path    = string
  }))
  description = "A list of CloudFront custom_error_response objects"
  default     = []
}

variable "zone_id" {
  type        = string
  description = "Target Route53 zone ID for new DNS record"
}

variable "app_hostname" {
  type        = string
  description = "Hostname to be used for DNS A record"
}

variable "service_account_name" {
  type        = string
  description = "Name of service account to create for deploying to S3"
}

variable "allowed_methods" {
  type        = list(string)
  description = "Methods allowed via cloudfront distribution"
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  type        = list(string)
  description = "Methods cached via cloudfront distribution"
  default     = ["GET", "HEAD"]
}

variable "forward_query_string" {
  type        = bool
  description = "Whether to forward query strings through cloudfront to the S3 bucket"
  default     = false
}

variable "min_ttl" {
  type        = number
  description = "Minimum TTL of cached objects"
  default     = 0
}

variable "default_ttl" {
  type        = number
  description = "Default TTL of cached objects"
  default     = 300
}

variable "max_ttl" {
  type        = number
  description = "Maximum TTL of cached objects"
  default     = 3600
}

variable "cloudfront_price_class" {
  type        = string
  description = "Cloudfront price class to use. See [CloudFront DistributionConfig](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html) for valid class names."
  default     = "PriceClass_100"
}

variable "geo_restriction_type" {
  type        = string
  description = "Must be one of 'none', 'whitelist', or 'blacklist'."
  default     = "none"
}

variable "geo_restriction_locations" {
  type        = list(string)
  description = "String list of ISO 3166-1-alpha-2 country codes to be used with geo_restriction_type."
  default     = []
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of ACM certificate resource located in us-east-1"
}

variable "cnames" {
  type        = list(string)
  description = "List of hostnames/CNAMEs the Cloudfront distribution should respond to"
}

variable "bucket_versioning" {
  type        = bool
  description = "Enable bucket versioning"
  default     = true
}
