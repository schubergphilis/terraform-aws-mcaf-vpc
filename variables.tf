variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "lambda_subnets" {
  type        = bool
  default     = false
  description = "Whether to create a subnet for Lambda functions running in the VPC"
}

variable "lambda_subnet_bits" {
  type        = number
  default     = 19
  description = "The number of bits used for the subnet mask"
}

variable "public_subnet_bits" {
  type        = number
  default     = 24
  description = "The number of bits used for the subnet mask"
}

variable "private_subnet_bits" {
  type        = number
  default     = 24
  description = "The number of bits used for the subnet mask"
}

variable "stack" {
  type        = string
  description = "The stack name for the VPC"
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
