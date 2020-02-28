# mcaf-terraform-aws-vpc

This module creates a VPC layout with private, (optional) public and lambda
subnets. It also sets up by default the necessary networking components like
gateways and routers.

```terraform
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
```
