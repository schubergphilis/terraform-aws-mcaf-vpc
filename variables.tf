variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
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

variable "private_s3_endpoint" {
  default     = false
  description = "Deploy an s3 endpoint for your private subnets"
}

variable "ssm_endpoint" {
  type = object({
    security_group_ids  = list(string)
    subnet_ids          = list(string)
    private_dns_enabled = bool
  })
  default = { security_group_ids = [],
    subnet_ids = [],
  private_dns_enabled = false }
  description = "Variables to provision an ssm endpoint to the VPC"
}

variable "ec2messages_endpoint" {
  type = object({
    security_group_ids  = list(string)
    subnet_ids          = list(string)
    private_dns_enabled = bool
  })
  default = { security_group_ids = [],
    subnet_ids = [],
  private_dns_enabled = false }
  description = "Variables to provision an ec2messages endpoint to the VPC"
}

variable "ec2_endpoint" {
  type = object({
    security_group_ids  = list(string)
    subnet_ids          = list(string)
    private_dns_enabled = bool
  })
  default = { security_group_ids = [],
    subnet_ids = [],
  private_dns_enabled = false }
  description = "Variables to provision an ec2 endpoint to the VPC"
}

variable "ssmmessages_endpoint" {
  type = object({
    security_group_ids  = list(string)
    subnet_ids          = list(string)
    private_dns_enabled = bool
  })
  default = { security_group_ids = [],
    subnet_ids = [],
  private_dns_enabled = false }
  description = "Variables to provision an ssmmessages endpoint to the VPC"
}
