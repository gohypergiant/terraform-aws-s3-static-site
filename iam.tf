// Copyright 2020 Hypergiant, LLC

data "aws_iam_policy_document" "s3-deployment" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
      "cloudfront:CreateInvalidation",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
      aws_s3_bucket.this.arn
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
      aws_s3_bucket.this.arn
    ]
  }
}

resource "aws_iam_policy" "s3-deployment" {
  name        = "${var.app_hostname}-s3-deployment-${random_id.iam.hex}"
  path        = "/"
  description = "Policy for allowing service-account/deployment access to ${aws_s3_bucket.this.id}"
  policy      = data.aws_iam_policy_document.s3-deployment.json
}

resource "aws_iam_user" "deployer" {
  name = var.service_account_name
  path = "/"
  // TODO: Figure out how to pass tags through into the module
}

resource "aws_iam_user_policy_attachment" "this" {
  // checkov:skip=CKV_AWS_40: Service account gets direct policy attachment
  user       = aws_iam_user.deployer.name
  policy_arn = aws_iam_policy.s3-deployment.arn
}
