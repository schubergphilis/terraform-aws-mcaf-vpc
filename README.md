# mcaf-terraform-aws-vpc

This module creates a VPC layout with private, (optional) public and lambda
subnets. It also sets up by default the necessary networking components like
gateways and routers.

```terraform
module "private_vpc" {
  source              = "git::git@github.com:schubergphilis/terraform-aws-mcaf-vpc.git"
  stack               = "test"
  cidr_block          = "10.0.0.0/8"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_only        = true
  lambda_subnets      = false
  private_subnet_bits = 16

  tags = {
    environment = "test"
  }
}
```
