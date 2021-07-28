# mcaf-terraform-aws-vpc

This module creates a VPC layout with private, public and lambda
subnets. It also sets up by default the necessary networking components like
gateways and routers.

All subnets are optional so you can decide which ones make sense for your
environment. See the examples directory for reference material.

```terraform
module "full_vpc" {
  source              = "github.com/schubergphilis/terraform-aws-mcaf-vpc"
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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.10 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | A list of availability zones for the subnets | `list(string)` | n/a | yes |
| cidr\_block | The CIDR block for the VPC | `string` | n/a | yes |
| name | Used as part of the resource names to indicate they are created and used within a specific name | `string` | n/a | yes |
| tags | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |
| dhcp\_options | DHCP options to assign to the VPC | <pre>object({<br>    domain_name          = string<br>    domain_name_servers  = list(string)<br>    netbios_name_servers = list(string)<br>    netbios_node_type    = number<br>    ntp_servers          = list(string)<br>  })</pre> | `null` | no |
| ebs\_endpoint | Variables to provision an EBS endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| ec2\_endpoint | Variables to provision an EC2 endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| ec2messages\_endpoint | Variables to provision an EC2 messages endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| ecr\_api\_endpoint | Variables to provision a ECR endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| enable\_nat\_gateway | Set to true to provision a NAT Gateway for each private subnet | `bool` | `true` | no |
| flow\_logs | Variables to enable flow logs for the VPC | <pre>object({<br>    iam_role_name     = string<br>    log_group_name    = string<br>    retention_in_days = number<br>    traffic_type      = string<br>  })</pre> | `null` | no |
| internet\_gateway\_tags | Additional tags to set on the internet gateway | `map(string)` | `{}` | no |
| lambda\_subnet\_bits | The number of bits used for the subnet mask | `number` | `null` | no |
| logs\_endpoint | Variables to provision a Log endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| postfix | Postfix the role and policy names with Role and Policy | `bool` | `false` | no |
| prepend\_resource\_type | If set it will prepend the resource type on the name of the resource. | `bool` | `false` | no |
| private\_dynamodb\_endpoint | Deploy a DynamoDB endpoint for your private subnets | `bool` | `false` | no |
| private\_s3\_endpoint | Deploy an S3 endpoint for your private subnets | `bool` | `false` | no |
| private\_subnet\_bits | The number of bits used for the subnet mask | `number` | `null` | no |
| private\_subnet\_tags | Additional tags to set on the private subnets | `map(string)` | `{}` | no |
| public\_subnet\_bits | The number of bits used for the subnet mask | `number` | `null` | no |
| public\_subnet\_tags | Additional tags to set on the public subnets | `map(string)` | `{}` | no |
| restrict\_default\_security\_group | Set to true to remove all rules from the default security group | `bool` | `true` | no |
| s3\_route\_table\_ids | Custom route table IDs for the S3 endpoint | `list(string)` | `null` | no |
| share\_private\_subnets | If set it will share the private subnets through resource access manager | `bool` | `false` | no |
| share\_public\_subnets | If set it will share the public subnets through resource access manager | `bool` | `false` | no |
| ssm\_endpoint | Variables to provision an SSM endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| ssmmessages\_endpoint | Variables to provision an SSM messages endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| subnet\_sharing\_custom\_tags | Custom tags to be added to a resource share for subnets | `map(string)` | `{}` | no |
| transfer\_server | Variables to provision a Transfer Server endpoint to the VPC | <pre>object({<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>    private_dns_enabled = bool<br>  })</pre> | `null` | no |
| vpc\_tags | Additional tags to set on the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cidr\_block | CIDR block of the VPC |
| id | ID of the VPC |
| igw\_id | ID of the Internet Gateway |
| lambda\_route\_table\_ids | IDs of the Lambda route tables |
| lambda\_subnet\_arns | ARNs of the Lambda subnets |
| lambda\_subnet\_cidr\_blocks | CIDR blocks of the Lambda subnets |
| lambda\_subnet\_ids | IDs of the Lambda subnets |
| name | The name provided for the VPC |
| nat\_gateway\_ids | IDs of the NAT gateways |
| private\_route\_table\_ids | IDs of the private route tables |
| private\_subnet\_arns | ARNs of the private subnets |
| private\_subnet\_cidr\_blocks | CIDR blocks of the private subnets |
| private\_subnet\_ids | IDs of the private subnets |
| public\_route\_table\_id | ID of the public route table |
| public\_subnet\_arns | ARNs of the public subnets |
| public\_subnet\_cidr\_blocks | CIDR blocks of the public subnets |
| public\_subnet\_ids | IDs of the public subnets |
| subnet\_share\_arn | The ARN of the subnet share in resource access manager if any |
| subnet\_share\_id | The ID of the subnet share in resource access manager if any |
| vpc\_endpoint\_ids | An object containing the ID of each created VPC endpoint |

<!--- END_TF_DOCS --->
