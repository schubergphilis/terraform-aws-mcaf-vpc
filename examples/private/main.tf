provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

module "private_vpc" {
  source              = "../../"
  stack               = "test"
  cidr_block          = "10.10.0.0/19"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_only        = true
  lambda_subnets      = false
  private_subnet_bits = 22

  tags = {
    environment = "test"
  }
}

module "private_vpc_with_lambdas" {
  source              = "../../"
  stack               = "test"
  cidr_block          = "10.11.0.0/19"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_only        = true
  lambda_subnets      = true
  private_subnet_bits = 22
  lambda_subnet_bits  = 22

  tags = {
    environment = "test"
  }
}
