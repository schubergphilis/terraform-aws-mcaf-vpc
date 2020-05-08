provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

module "private_vpc" {
  source             = "../../"
  domain_name        = "test"
  cidr_block         = "192.168.0.0/24"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  lambda_subnet_bits = 26

  tags = {
    environment = "test"
  }
}
