output "s3_bucket_name" {
  value = aws_s3_bucket.this.name
}

output "iam_polcy_arn" {
  value = aws_iam_policy.s3-deployment.arn
}

output "service_account_name" {
  value = aws_iam_user.deployer.name
}

