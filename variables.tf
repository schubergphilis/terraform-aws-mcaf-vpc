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

variable "extra_bits_per_subnet" {
  type        = number
  default     = 8
  description = "The number of additional bits with which to extend the prefix, if given a prefix ending in /16 and a extra_bits_per_subnet value of 4, the resulting subnet address will have length /20"
}
