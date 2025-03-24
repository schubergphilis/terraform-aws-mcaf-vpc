provider "aws" {
  region = "eu-west-1"
}

module "kms" {
  source  = "schubergphilis/mcaf-kms/aws"
  version = "~> 0.3"

  name = "vpc-flow-log"
}

# VPC with flow logs to CloudWatch
module "vpc_flow_log_cloudwatch" {
  source             = "../../"
  name               = "vpc-flow-log-cloudwatch"
  cidr_block         = "192.168.0.0/24"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_bits = 26

  flow_logs_cloudwatch = {
    kms_key_arn = module.kms.arn
  }
}

# VPC with flow logs to S3 bucket created by this module
module "vpc_flow_log_s3" {
  source             = "../../"
  name               = "vpc-flow-log-s3"
  cidr_block         = "192.168.0.0/24"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_bits = 26

  flow_logs_s3 = {
    kms_key_arn = module.kms.arn
    bucket_name = "vpc-flow-log-bucket"
  }
}

# VPC with flow logs to S3 bucket created outside of this module
module "s3" {
  source  = "schubergphilis/mcaf-s3/aws"
  version = "~> 1.2"

  name_prefix = "vpc-flow-log"
}

module "vpc_flow_log_s3_custom_bucket" {
  source             = "../../"
  name               = "vpc-flow-log-s3"
  cidr_block         = "192.168.0.0/24"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_bits = 26

  # log_destination accepts full S3 ARNs, optionally including keys. Example:
  # "s3://{bucket_name}/{key_name}" will create a folder in the S3 bucket with the {key_name}
  flow_logs_s3 = {
    kms_key_arn     = module.kms.arn
    log_destination = module.s3.arn
  }
}
