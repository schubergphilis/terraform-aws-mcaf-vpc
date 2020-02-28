provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

module "full_vpc" {
  source              = "../../"
  stack               = "test"
  cidr_block          = "192.168.0.0/24"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets     = true
  private_subnet_bits = 28
  public_subnets      = true
  public_subnet_bits  = 28
  lambda_subnets      = false

  tags = {
    environment = "test"
  }
}

module "full_vpc_with_lambda" {
  source              = "../../"
  stack               = "test"
  cidr_block          = "192.168.1.0/24"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets     = true
  private_subnet_bits = 28
  public_subnets      = true
  public_subnet_bits  = 28
  lambda_subnets      = true
  lambda_subnet_bits  = 28

  tags = {
    environment = "test"
  }
}
