# mcaf-terraform-aws-vpc

This module creates a VPC layout with private, public and lambda
subnets. It also sets up by default the necessary networking components like
gateways and routers.

All subnets are optional so you can decide which ones make sense for your
environment. See the examples directory for reference material.

```terraform
module "full_vpc" {
  source              = "git::git@github.com:schubergphilis/terraform-aws-mcaf-vpc.git"
  name                = "test"
  cidr_block          = "192.168.0.0/24"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_bits  = 28
  private_subnet_bits = 28

  tags = {
    environment = "test"
  }
}
```
