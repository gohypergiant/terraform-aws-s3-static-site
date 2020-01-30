output "s3_bucket_name" {
  description = "Name of S3 bucket created"
  value       = aws_s3_bucket.this.name
}

output "iam_policy_arn" {
  description = "ARN of IAM policy for writing to static site bucket"
  value       = aws_iam_policy.s3-deployment.arn
}

output "service_account_name" {
  description = "Name of IAM service account that can write to the bucket"
  value       = aws_iam_user.deployer.name
}
