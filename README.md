# S3 Static Site Module

This module provides the resources, IAM policies, and configuration for setting up your public, S3-hosted static site.

This Module includes:
 - S3 bucket
 - IAM user with read, write, and delete policy scoped to the bucket
 - Route53 A-record with Alias pointing to S3 bucket

## How do you use this Module?
This module requires that you provide it a Route53 zone. Aside from that, it needs no other preexisting resources.

After initializing and running terraform with this module, you will have an S3 bucket with a public-read ACL,
IAM policy, and IAM user that can be used as a service account, such as for automating deployments with CI/CD
pipelines.

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such
as a database or server cluster. Each Module is created primarily using [Terraform](https://www.terraform.io/),
includes automated tests, examples, and documentation, and is maintained both by the open source community and
companies that provide commercial support.

Instead of having to figure out the details of how to run a piece of infrastructure from scratch, you can reuse
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself,
you can leverage the work of the Module community and maintainers, and pick up infrastructure improvements through
a version number bump.

## Who maintains this Module?

This module is maintained by the Hypergiant Infrastructure Engineering Team

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.

