# S3 Static Site Module

![Checkov](https://github.com/gohypergiant/terraform-aws-s3-static-site/workflows/Checkov/badge.svg)

[![Hypergiant](https://i.imgur.com/cLjriJj.jpg)](https://www.hypergiant.com/)

This module provides the resources, IAM policies, and configuration for setting up your public, S3-hosted static site with a Cloudfront distribution.

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

No requirements.

## Providers

| Name   | Version |
| ------ | ------- |
| aws    | n/a     |
| random | n/a     |

## Inputs

| Name                      | Description                                                                                                                                                                       | Type                                                                                                                                                   | Default                                                | Required |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------ | :------: |
| acm_certificate_arn       | ARN of ACM certificate resource located in us-east-1                                                                                                                              | `string`                                                                                                                                               | n/a                                                    |   yes    |
| app_hostname              | Hostname to be used for DNS A record                                                                                                                                              | `string`                                                                                                                                               | n/a                                                    |   yes    |
| bucket_name               | Name of bucket for static site                                                                                                                                                    | `string`                                                                                                                                               | n/a                                                    |   yes    |
| cnames                    | List of hostnames/CNAMEs the Cloudfront distribution should respond to                                                                                                            | `list(string)`                                                                                                                                         | n/a                                                    |   yes    |
| log_bucket_name           | Name of S3 bucket to create for storing logs                                                                                                                                      | `string`                                                                                                                                               | n/a                                                    |   yes    |
| log_prefix                | Prefix to use for S3 bucket logging.                                                                                                                                              | `string`                                                                                                                                               | n/a                                                    |   yes    |
| service_account_name      | Name of service account to create for deploying to S3                                                                                                                             | `string`                                                                                                                                               | n/a                                                    |   yes    |
| zone_id                   | Target Route53 zone ID for new DNS record                                                                                                                                         | `string`                                                                                                                                               | n/a                                                    |   yes    |
| allowed_methods           | Methods allowed via cloudfront distribution                                                                                                                                       | `list(string)`                                                                                                                                         | <pre>[<br> "GET",<br> "HEAD",<br> "OPTIONS"<br>]</pre> |    no    |
| bucket_versioning         | Enable bucket versioning                                                                                                                                                          | `bool`                                                                                                                                                 | `true`                                                 |    no    |
| cached_methods            | Methods cached via cloudfront distribution                                                                                                                                        | `list(string)`                                                                                                                                         | <pre>[<br> "GET",<br> "HEAD"<br>]</pre>                |    no    |
| cloudfront_price_class    | Cloudfront price class to use. See [CloudFront DistributionConfig](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html) for valid class names. | `string`                                                                                                                                               | `"PriceClass_100"`                                     |    no    |
| custom_error_response     | A list of CloudFront custom_error_response objects                                                                                                                                | <pre>list(object({<br> error_caching_min_ttl = number<br> error_code = number<br> response_code = number<br> response_page_path = string<br> }))</pre> | `[]`                                                   |    no    |
| default_ttl               | Default TTL of cached objects                                                                                                                                                     | `number`                                                                                                                                               | `86400`                                                |    no    |
| enable_spa                | Enable SPA error handler. Disable for true multi-page behavior                                                                                                                    | `bool`                                                                                                                                                 | `true`                                                 |    no    |
| error_document            | Error document for static site                                                                                                                                                    | `string`                                                                                                                                               | `"error.html"`                                         |    no    |
| forward_query_string      | Whether to forward query strings through cloudfront to the S3 bucket                                                                                                              | `bool`                                                                                                                                                 | `false`                                                |    no    |
| geo_restriction_locations | String list of ISO 3166-1-alpha-2 country codes to be used with geo_restriction_type.                                                                                             | `list(string)`                                                                                                                                         | `[]`                                                   |    no    |
| geo_restriction_type      | Must be one of 'none', 'whitelist', or 'blacklist'.                                                                                                                               | `string`                                                                                                                                               | `"none"`                                               |    no    |
| index_document            | Index document for static site                                                                                                                                                    | `string`                                                                                                                                               | `"index.html"`                                         |    no    |
| max_ttl                   | Maximum TTL of cached objects                                                                                                                                                     | `number`                                                                                                                                               | `86400`                                                |    no    |
| min_ttl                   | Minimum TTL of cached objects                                                                                                                                                     | `number`                                                                                                                                               | `86400`                                                |    no    |
| proxies                   | Paths to proxies and their destinations, no wildcards                                                                                                                             | <pre>list(object({<br> destination = object({<br> domain = string<br> path = string<br> })<br> path = string<br> }))</pre>                             | `[]`                                                   |    no    |
| region                    | AWS Region                                                                                                                                                                        | `string`                                                                                                                                               | `""`                                                   |    no    |

## Outputs

| Name                 | Description                                              |
| -------------------- | -------------------------------------------------------- |
| iam_policy_arn       | ARN of IAM policy for writing to static site bucket      |
| s3_bucket_arn        | ARN of S3 bucket created                                 |
| s3_bucket_id         | Name of S3 bucket created                                |
| s3_bucket_name       | Name of S3 bucket created                                |
| service_account_name | Name of IAM service account that can write to the bucket |

## Who maintains this Module?

This module is maintained by the Hypergiant Infrastructure Engineering Team.

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, along with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, MINOR, and PATCH versions on each release to indicate any incompatibilities.

## Contributing

See our [Contributing Guidelines](contributing.md).

## License

This repository is licensed under [Apache 2.0](LICENSE.md).
