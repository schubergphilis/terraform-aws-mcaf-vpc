variable "stack" {
  type        = string
  description = "The stack name for the VPC"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones for the subnets"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources"
}

variable "lambda_subnet" {
  type        = bool
  default     = false
  description = "Whether to create a subnet for Lambda functions running in the VPC"
}

variable "public_subnet_suffix" {
  type        = number
  default     = 24
  description = "The suffix specifying the size of the Public subnets, e.g. (default) value 24 results in /24 subnets"
}

variable "private_subnet_suffix" {
  type        = number
  default     = 24
  description = "The suffix specifying the size of the Private subnets, e.g. (default) value 24 results in /24 subnets"
}

variable "lambda_subnet_suffix" {
  type        = number
  default     = 19
  description = "The suffix specifying the size of the Lambda subnets, e.g. (default) value 19 results in /19 subnets"
}

