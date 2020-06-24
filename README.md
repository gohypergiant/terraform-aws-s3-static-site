# S3 Static Site Module

![Checkov](https://github.com/gohypergiant/terraform-aws-s3-static-site/workflows/Checkov/badge.svg)

[![Hypergiant](https://i.imgur.com/cLjriJj.jpg)](https://www.hypergiant.com/)

This module provides the resources, IAM policies, and configuration for setting up your public, S3-hosted static site with a Cloudfront distribution

This Module includes:
 - S3 bucket
 - IAM user with read, write, and delete policy scoped to the bucket
 - Route53 A-record with Alias pointing to Cloudfront distribution
 - IAM policy for attaching to principals such as users, roles, or groups to grant write access to the S3 bucket backing Cloudfront

## How do you use this Module?
This module requires that you provide it a Route53 zone and an AWS provider in `us-east-1`. If you are running your infrastructure in a region outside `us-east-1`, initialize a new provider and pass that to the module as show in our [examples](exmaples/complete/main.tf). This is because Cloudfront requires that certificates it uses be created in us-east-1, so all the regionally bound resources must also be in us-east-1.

After initializing and running terraform with this module, you will have an S3 bucket with a public-read ACL, IAM policy, and IAM user that can be used as a service account, such as for automating deployments with CI/CD pipelines.

## Who maintains this Module?

This module is maintained by the Hypergiant Infrastructure Engineering Team

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.

