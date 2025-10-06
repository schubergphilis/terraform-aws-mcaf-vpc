# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v3.0.0

## Key Changes

- This module now requires a minimum AWS provider version of 6.0 to support the `region` parameter. If you are using multiple AWS provider blocks, please read [migrating from multiple provider configurations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/enhanced-region-support#migrating-from-multiple-provider-configurations).
- Remove the option to prepend resource type to resource names.

#### Variables

The following variable have been removed:

* `prepend_resource_type`. This variable is not deemed necessary anymore and is assumed unused. Prefixing resources with resources is considered unnecessary and can lead to overly long names.
* `flow_logs_s3`:
  - `kms_key_arn` is now optional. Although it is highly recommended to use a KMS key to encrypt VPC Flow Logs, it is no longer enforced.
* `flow_logs_cloudwatch`:
  - `kms_key_arn` is now optional. Although it is highly recommended to use a KMS key to encrypt VPC Flow Logs, it is no longer enforced.

The following variables have been modified:

- `flow_logs_s3`:
  - `kms_key_arn` is now optional since [Cloudwatch log groups are encrypted by default]https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html).

- `flow_logs`:
  - `kms_key_arn` is now optional since [Cloudwatch log groups are encrypted by default]https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html).

### Behaviour

The subnet sharing features is refactored which could lead to the recreation of the `aws_ram_resource_association` resources of the subnets.

## Upgrading to v2.0.0

### Key Changes

- Enhanced VPC Flow logs features for improved functionality.
- Bug Fix: The S3 bucket lifecycle configuration for VPC Flow Logs now includes expiration, which was previously missing.
- Enhance security: require a KMS key to encrypt VPC Flow Logs. These logs contain sensitive network traffic information, such as IP addresses and ports, which could be misused if not properly protected.

#### Variables

The following variables have been modified:

- `flow_logs_s3`:
  - `kms_key_arn` has been added as mandatory variable.
  - `bucket_arn` has been renamed to `log_destination` for clarity, reflecting that both a bucket and bucket keys are accepted, aligning better with the actual resource.
  - `destination_options.per_hour_partition` has been added with `true` as default as is the best practice since this reduces the cost and response time for queries.

- `flow_logs` is renamed to `flow_logs_cloudwatch`:
  - `kms_key_arn` has been added as mandatory variable.

- `postfix` is renamed to `flow_logs_cloudwatch.iam_role_postfix`. Default has been changed to `true`.
