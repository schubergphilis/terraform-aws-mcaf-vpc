variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "cidr_block" {
  type        = string
  default     = null
  description = "The CIDR block for the VPC"
}

variable "codebuild_interface_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision a CodeBuild endpoint to the VPC"
}

variable "dhcp_options" {
  type = object({
    domain_name          = string
    domain_name_servers  = list(string)
    netbios_name_servers = list(string)
    netbios_node_type    = number
    ntp_servers          = list(string)
  })
  default     = null
  description = "DHCP options to assign to the VPC"
}

variable "ebs_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an EBS endpoint to the VPC"
}

variable "ec2_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an EC2 endpoint to the VPC"
}

variable "ec2messages_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an EC2 messages endpoint to the VPC"
}

variable "ecr_api_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an ECR endpoint to the VPC"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Set to true to provision a NAT Gateway for each private subnet"
}

variable "enable_private_default_route" {
  type        = bool
  default     = true
  description = "Set to true to add a default route to the NAT gateway for each private subnet"
}

variable "flow_logs_s3" {
  type = object({
    bucket_name              = optional(string)
    kms_key_arn              = optional(string)
    log_destination          = optional(string)
    log_format               = optional(string)
    max_aggregation_interval = optional(number, 60)
    retention_in_days        = optional(number, 90)
    traffic_type             = optional(string, "ALL")

    destination_options = optional(object({
      file_format                = optional(string)
      hive_compatible_partitions = optional(bool)
      per_hour_partition         = optional(bool, true)
    }), {})
  })
  default     = null
  description = "Variables to enable flow logs stored in S3 for the VPC. Use 'bucket_name' to log to an S3 bucket created by this module. Alternatively, use 'log_destination' to specify a self-managed S3 bucket. The 'log_destination' variable accepts full S3 ARNs, optionally including object keys."

  validation {
    condition     = var.flow_logs_s3 == null || (try(var.flow_logs_s3.log_destination, null) != null || try(var.flow_logs_s3.bucket_name, null) != null)
    error_message = "Either log_destination or bucket_name must be specified in flow_logs_s3 if the configuration is provided."
  }
}

variable "flow_logs_cloudwatch" {
  type = object({
    iam_role_name                = optional(string, "VpcFlowLogs")
    iam_role_name_prefix         = optional(string)
    iam_role_postfix             = optional(bool, true)
    iam_role_path                = optional(string, "/")
    iam_role_permission_boundary = optional(string)
    kms_key_arn                  = optional(string)
    log_format                   = optional(string)
    log_group_name               = optional(string)
    max_aggregation_interval     = optional(number, 60)
    retention_in_days            = optional(number, 90)
    traffic_type                 = optional(string, "ALL")
  })
  default     = null
  description = "Variables to enable flow logs for the VPC"

  validation {
    condition     = var.flow_logs_cloudwatch == null || !(try(var.flow_logs_cloudwatch.iam_name, null) != null && try(var.flow_logs_cloudwatch.iam_name_prefix, null) != null)
    error_message = "Only one of iam_name or iam_name_prefix can be defined."
  }
}

variable "internet_gateway_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to set on the internet gateway"
}

variable "ipv4_ipam" {
  type = object({
    pool_id        = string
    netmask_length = number
  })
  default     = null
  description = "The IPv4 IPAM configuration to use for the VPC"
}

variable "lambda_subnet_bits" {
  type        = number
  default     = null
  description = "The number of bits used for the subnet mask"
}

variable "logs_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision a log endpoint to the VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "Whether public IP addresses are assigned on instance launch"
}

variable "mgn_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an MGN endpoint to the VPC"
}

variable "name" {
  type        = string
  description = "Used as part of the resource names to indicate they are created and used within a specific name"
}

variable "private_subnet_bits" {
  type        = number
  default     = null
  description = "The number of bits used for the subnet mask"
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to set on the private subnets"
}

variable "public_subnet_bits" {
  type        = number
  default     = null
  description = "The number of bits used for the subnet mask"
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to set on the public subnets"
}

variable "private_dynamodb_endpoint" {
  type        = bool
  default     = false
  description = "Deploy a DynamoDB endpoint for your private subnets"
}

variable "private_s3_endpoint" {
  type        = bool
  default     = false
  description = "Deploy an S3 endpoint for your private subnets"
}

variable "region" {
  type        = string
  default     = null
  description = "The AWS region where resources will be created; if omitted the default provider region is used"
}

variable "restrict_default_security_group" {
  type        = bool
  default     = true
  description = "Set to true to remove all rules from the default security group"
}

variable "s3_interface_endpoint" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default     = null
  description = "Variables to provision an S3 interface endpoint to the VPC"
}

variable "s3_route_table_ids" {
  type        = list(string)
  default     = null
  description = "Custom route table IDs for the S3 endpoint"
}

variable "share_private_subnets" {
  type        = bool
  default     = false
  description = "If set it will share the private subnets through resource access manager"
}

variable "share_public_subnets" {
  type        = bool
  default     = false
  description = "If set it will share the public subnets through resource access manager"
}

variable "shared_public_route_table" {
  type        = bool
  default     = true
  description = "Determines weather to use a single route table for all public networks"
}

variable "ssm_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an SSM endpoint to the VPC"
}

variable "ssmmessages_endpoint" {
  type = object({
    private_dns_enabled = bool
    security_group_ids  = list(string)
    subnet_ids          = list(string)
  })
  default     = null
  description = "Variables to provision an SSM messages endpoint to the VPC"
}

variable "subnet_sharing_custom_tags" {
  type        = map(string)
  default     = {}
  description = "Custom tags to be added to a resource share for subnets"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to all resources"
}

variable "transfer_server" {
  type = object({
    security_group_ids  = list(string)
    subnet_ids          = list(string)
    private_dns_enabled = bool
  })
  default     = null
  description = "Variables to provision a Transfer Server endpoint to the VPC"
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to set on the VPC"
}
