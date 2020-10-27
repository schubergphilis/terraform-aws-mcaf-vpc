variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Set to true to provision a NAT Gateway for each private subnet"
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
