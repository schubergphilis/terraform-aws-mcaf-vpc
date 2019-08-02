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
