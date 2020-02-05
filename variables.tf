variable "bucket_name" {
  type        = string
  description = "Name of bucket for static site"
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
  description = "Cloudfront price class to use. See https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html for valid class names."
  default     = "PriceClass_100"
}
