# S3 Static Site Module

![Checkov](https://github.com/gohypergiant/terraform-aws-s3-static-site/workflows/Checkov/badge.svg)

[![Hypergiant](https://i.imgur.com/cLjriJj.jpg)](https://www.hypergiant.com/)

This module provides the resources, IAM policies, and configuration for setting up your public, S3-hosted static site with a Cloudfront distribution.

**Important!** Version 1.0 has breaking changes from previous releases.

### What changed in 1.0?
AWS provider >=3.0 has removed the region field in aws_s3_bucket, instead inferring it from provider used to create the bucket. In order to prevent problems with resource recreation and broken deployments, we are capping the provider to 2.x.

Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade#resource-aws_s3_bucket

Because a resource is tied to the provider that created it, passing a new aliased provider to the module with the same region will not resolve the regional issue. The usage of the module should continue as before, but users who have created the bucket in a region other than `us-east-1` will experience breaking changes if they attempt to continue to use the same bucket.

## Resources created
This Module includes:

- S3 bucket
- IAM user with read, write, and delete policy scoped to the bucket
- Route53 A-record with Alias pointing to Cloudfront distribution
- IAM policy for attaching to principals such as users, roles, or groups to grant write access to the S3 bucket backing Cloudfront
- ⚠️ CloudFront is configured in SPA mode by default

## How do you use this Module?

This module requires that you provide it a Route53 zone and an AWS provider in `us-east-1`. If you are running your infrastructure in a region outside `us-east-1`, initialize a new provider and pass that to the module as shown in our [examples](exmaples/complete/main.tf). This is because Cloudfront requires that certificates it uses be created in us-east-1, so all the regionally bound resources must also be in us-east-1.

After initializing and running terraform with this module, you will have an S3 bucket with a public-read ACL, IAM policy, and IAM user that can be used as a service account, such as for automating deployments with CI/CD pipelines.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acm\_certificate\_arn | ARN of ACM certificate resource located in us-east-1 | `string` | n/a | yes |
| app\_hostname | Hostname to be used for DNS A record | `string` | n/a | yes |
| bucket\_name | Name of bucket for static site | `string` | n/a | yes |
| cnames | List of hostnames/CNAMEs the Cloudfront distribution should respond to | `list(string)` | n/a | yes |
| log\_bucket\_name | Name of S3 bucket to create for storing logs | `string` | n/a | yes |
| log\_prefix | Prefix to use for S3 bucket logging. | `string` | n/a | yes |
| service\_account\_name | Name of service account to create for deploying to S3 | `string` | n/a | yes |
| zone\_id | Target Route53 zone ID for new DNS record | `string` | n/a | yes |
| allowed\_methods | Methods allowed via cloudfront distribution | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD",<br>  "OPTIONS"<br>]</pre> | no |
| bucket\_versioning | Enable bucket versioning | `bool` | `true` | no |
| cached\_methods | Methods cached via cloudfront distribution | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| cloudfront\_price\_class | Cloudfront price class to use. See [CloudFront DistributionConfig](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html) for valid class names. | `string` | `"PriceClass_100"` | no |
| custom\_error\_response | A list of CloudFront custom\_error\_response objects | <pre>list(object({<br>    error_caching_min_ttl = number<br>    error_code            = number<br>    response_code         = number<br>    response_page_path    = string<br>  }))</pre> | `[]` | no |
| default\_ttl | Default TTL of cached objects | `number` | `86400` | no |
| enable\_spa | Enable SPA error handler. Disable for true multi-page behavior | `bool` | `true` | no |
| error\_document | Error document for static site | `string` | `"error.html"` | no |
| forward\_query\_string | Whether to forward query strings through cloudfront to the S3 bucket | `bool` | `false` | no |
| geo\_restriction\_locations | String list of ISO 3166-1-alpha-2 country codes to be used with geo\_restriction\_type. | `list(string)` | `[]` | no |
| geo\_restriction\_type | Must be one of 'none', 'whitelist', or 'blacklist'. | `string` | `"none"` | no |
| index\_document | Index document for static site | `string` | `"index.html"` | no |
| max\_ttl | Maximum TTL of cached objects | `number` | `86400` | no |
| min\_ttl | Minimum TTL of cached objects | `number` | `86400` | no |
| proxies | Paths to proxies and their destinations, no wildcards | <pre>list(object({<br>    destination = object({<br>      domain = string<br>      path   = string<br>    })<br>    path = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_policy\_arn | ARN of IAM policy for writing to static site bucket |
| s3\_bucket\_arn | ARN of S3 bucket created |
| s3\_bucket\_id | Name of S3 bucket created |
| s3\_bucket\_name | Name of S3 bucket created |
| service\_account\_name | Name of IAM service account that can write to the bucket |


## Who maintains this Module?

This module is maintained by the Hypergiant Infrastructure Engineering Team.

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, along with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, MINOR, and PATCH versions on each release to indicate any incompatibilities.

## Contributing

See our [Contributing Guidelines](contributing.md).

## License

This repository is licensed under [Apache 2.0](LICENSE.md).
