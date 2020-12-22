variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
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

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Set to true to provision a NAT Gateway for each private subnet"
}

variable "flow_logs" {
  type = object({
    iam_role_name     = string
    retention_in_days = number
    traffic_type      = string
  })
  default     = null
  description = "Variables to enable flow logs for the VPC"
}

variable "lambda_subnet_bits" {
  type        = number
  default     = null
  description = "The number of bits used for the subnet mask"
}

variable "name" {
  type        = string
  description = "Used as part of the resource names to indicate they are created and used within a specific name"
}

variable "postfix" {
  type        = bool
  default     = false
  description = "Postfix the role and policy names with Role and Policy"
}

variable "prepend_resource_type" {
  type        = bool
  default     = false
  description = "If set it will prepend the resource type on the name of the resource."
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
  default     = false
  description = "Deploy a DynamoDB endpoint for your private subnets"
}

variable "private_s3_endpoint" {
  default     = false
  description = "Deploy an S3 endpoint for your private subnets"
}

variable "restrict_default_security_group" {
  type        = bool
  default     = true
  description = "Remove all rules from the default security group"
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
  description = "A mapping of tags to assign to the resources"
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
