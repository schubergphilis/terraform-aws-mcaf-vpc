locals {
  store_logs_in_s3 = (var.flow_logs_s3 != null)
  create_bucket    = var.flow_logs_s3 != null && try(var.flow_logs_s3.bucket_arn == null, false)
}

module "log_bucket" {
  source  = "schubergphilis/mcaf-s3/aws"
  version = "~> 1.2.0"

  count = local.create_bucket ? 1 : 0

  name        = var.s3_flow_logs_configuration.bucket_name
  kms_key_arn = var.s3_flow_logs_configuration.kms_key_arn
  tags        = var.tags

  lifecycle_rule = [
    {
      id      = "retention"
      enabled = true

      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }

      noncurrent_version_expiration = {
        noncurrent_days = var.flow_logs_s3.retention_in_days
      }

      expiration = {
        days = var.flow_logs_s3.retention_in_days
      }
    }
  ]

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.flow_logs_s3.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.flow_logs_s3.bucket_name}",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
                }
            }
        }
    ]
}
EOF
}

resource "aws_flow_log" "flow_logs_s3" {
  count = local.store_logs_in_s3 ? 1 : 0

  log_destination          = local.create_bucket ? module.log_bucket[count.index].arn : var.flow_logs_s3.bucket_arn
  log_destination_type     = "s3"
  log_format               = var.flow_logs_s3.log_format
  max_aggregation_interval = var.flow_logs_s3.max_aggregation_interval
  tags                     = var.tags
  traffic_type             = var.flow_logs_s3.traffic_type
  vpc_id                   = aws_vpc.default.id

  destination_options {
    file_format                = var.s3_flow_logs_configuration.destination_options.file_format
    hive_compatible_partitions = var.s3_flow_logs_configuration.destination_options.hive_compatible_partitions
    per_hour_partition         = var.s3_flow_logs_configuration.destination_options.per_hour_partition
  }
}
