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

variable "route53_zone" {
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
