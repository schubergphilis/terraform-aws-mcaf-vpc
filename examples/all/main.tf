provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

module "full_vpc" {
  source              = "../../"
  name                = "test"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr_block          = "192.168.0.0/24"
  private_subnet_bits = 28
  public_subnet_bits  = 28
  tags = {
    environment = "test"
  }
}

module "full_vpc_with_lambda" {
  source              = "../../"
  name                = "test"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr_block          = "192.168.1.0/24"
  lambda_subnet_bits  = 28
  private_subnet_bits = 28
  public_subnet_bits  = 28
  tags = {
    environment = "test"
  }
}

module "full_vpc_with_s3_endpoint" {
  source              = "../../"
  name                = "test"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr_block          = "192.168.1.0/24"
  private_s3_endpoint = true
  private_subnet_bits = 28
  public_subnet_bits  = 28
  tags = {
    environment = "test"
  }
}

module "full_vpc_with_ssm_endpoints" {
  source              = "../../"
  name                = "test"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr_block          = "192.168.1.0/24"
  private_subnet_bits = 28
  public_subnet_bits  = 28
  tags = {
    environment = "test"
  }

  ec2_endpoint = {
    subnet_ids          = module.full_vpc_with_ssm_endpoints.private_subnet_ids
    private_dns_enabled = true
    security_group_ids  = []
  }

  ec2messages_endpoint = {
    subnet_ids          = module.full_vpc_with_ssm_endpoints.private_subnet_ids
    private_dns_enabled = true
    security_group_ids  = []
  }

  ssm_endpoint = {
    subnet_ids          = module.full_vpc_with_ssm_endpoints.private_subnet_ids
    private_dns_enabled = true
    security_group_ids  = []
  }
  
  ssmmessages_endpoint = {
    subnet_ids          = module.full_vpc_with_ssm_endpoints.private_subnet_ids
    private_dns_enabled = true
    security_group_ids  = []
  }
}
