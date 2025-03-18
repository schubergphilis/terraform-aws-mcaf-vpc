# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v2.0.0

### Key Changes

- Enhanced VPC Flow logs features for improved functionality.
- Bug Fix: The S3 bucket lifecycle configuration for VPC Flow Logs now includes expiration, which was previously missing.

#### Variables

The following variables have been modified:

- `flow_logs_s3`:
  - `kms_key_arn` has been added as mandatory variable.
  - `destination_options.per_hour_partition` has been added with `true` as default as is the best practice since this reduces the cost and response time for queries.

- `flow_logs` is renamed to `flow_logs_cloudwatch`:
  - `kms_key_arn` has been added as mandatory variable.
  - `iam_role_name`  is not the default anymore. `iam_role_name_prefix` is the modules default.

- `postfix` is renamed to `flow_logs_cloudwatch.iam_role_postfix`. Default has been changed to `true`.
