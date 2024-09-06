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
| flow\_logs\_s3 | Variables to enable flow logs for the VPC stored in an S3 bucket| <pre>object({<br>    bucket_name    = optional(string, true)<br>    create_bucket = optional(bool, true)<br>    retention_in_Days = number<br>    traffic_type      = string<br>  })</pre> | `null` | no |
| flow\_logs | Variables to enable flow logs for the VPC stored in CloudWatch Logs| <pre>object({<br>    iam_role_name     = string<br>    log_group_name    = string<br>    retention_in_days = number<br>    traffic_type      = string<br>  })</pre> | `null` | no |
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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_flow_logs_role"></a> [flow\_logs\_role](#module\_flow\_logs\_role) | schubergphilis/mcaf-role/aws | ~> 0.4.0 |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | schubergphilis/mcaf-s3/aws | ~> 0.14.1 |
| <a name="module_subnet_sharing"></a> [subnet\_sharing](#module\_subnet\_sharing) | github.com/schubergphilis/terraform-aws-mcaf-subnet-sharing | v0.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_flow_log.flow_logs_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_internet_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.codebuild_interface_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ebs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ec2_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ec2messages_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.mgn_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3_interface_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssmmessages_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.log_stream_action](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_endpoint_service.ebs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ec2_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ec2messages_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ssm_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ssmmessages_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of availability zones for the subnets | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Used as part of the resource names to indicate they are created and used within a specific name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC | `string` | `null` | no |
| <a name="input_codebuild_interface_endpoint"></a> [codebuild\_interface\_endpoint](#input\_codebuild\_interface\_endpoint) | Variables to provision a CodeBuild endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_dhcp_options"></a> [dhcp\_options](#input\_dhcp\_options) | DHCP options to assign to the VPC | <pre>object({<br>    domain_name          = string<br>    domain_name_servers  = list(string)<br>    netbios_name_servers = list(string)<br>    netbios_node_type    = number<br>    ntp_servers          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ebs_endpoint"></a> [ebs\_endpoint](#input\_ebs\_endpoint) | Variables to provision an EBS endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ec2_endpoint"></a> [ec2\_endpoint](#input\_ec2\_endpoint) | Variables to provision an EC2 endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ec2messages_endpoint"></a> [ec2messages\_endpoint](#input\_ec2messages\_endpoint) | Variables to provision an EC2 messages endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ecr_api_endpoint"></a> [ecr\_api\_endpoint](#input\_ecr\_api\_endpoint) | Variables to provision an ECR endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Set to true to provision a NAT Gateway for each private subnet | `bool` | `true` | no |
| <a name="input_enable_private_default_route"></a> [enable\_private\_default\_route](#input\_enable\_private\_default\_route) | Set to true to add a default route to the NAT gateway for each private subnet | `bool` | `true` | no |
| <a name="input_flow_logs"></a> [flow\_logs](#input\_flow\_logs) | Variables to enable flow logs for the VPC | <pre>object({<br>    iam_role_name                = string<br>    iam_role_permission_boundary = optional(string, null)<br>    log_format                   = optional(string, null)<br>    log_group_name               = string<br>    retention_in_days            = number<br>    traffic_type                 = string<br>  })</pre> | `null` | no |
| <a name="input_flow_logs_s3"></a> [flow\_logs\_s3](#input\_flow\_logs\_s3) | Variables to enable flow logs stored in S3 for the VPC. When bucket\_arn is specified, it will not create a new bucket. | <pre>object({<br>    bucket_name       = optional(string, null)<br>    bucket_arn        = optional(string, null)<br>    log_format        = optional(string, null)<br>    retention_in_days = number<br>    traffic_type      = string<br>  })</pre> | `null` | no |
| <a name="input_internet_gateway_tags"></a> [internet\_gateway\_tags](#input\_internet\_gateway\_tags) | Additional tags to set on the internet gateway | `map(string)` | `{}` | no |
| <a name="input_ipv4_ipam"></a> [ipv4\_ipam](#input\_ipv4\_ipam) | The IPv4 IPAM configuration to use for the VPC | <pre>object({<br>    pool_id        = string<br>    netmask_length = number<br>  })</pre> | `null` | no |
| <a name="input_lambda_subnet_bits"></a> [lambda\_subnet\_bits](#input\_lambda\_subnet\_bits) | The number of bits used for the subnet mask | `number` | `null` | no |
| <a name="input_logs_endpoint"></a> [logs\_endpoint](#input\_logs\_endpoint) | Variables to provision a log endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Whether public IP addresses are assigned on instance launch | `bool` | `false` | no |
| <a name="input_mgn_endpoint"></a> [mgn\_endpoint](#input\_mgn\_endpoint) | Variables to provision an MGN endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_postfix"></a> [postfix](#input\_postfix) | Postfix the role and policy names with Role and Policy | `bool` | `false` | no |
| <a name="input_prepend_resource_type"></a> [prepend\_resource\_type](#input\_prepend\_resource\_type) | If set it will prepend the resource type on the name of the resource. | `bool` | `false` | no |
| <a name="input_private_dynamodb_endpoint"></a> [private\_dynamodb\_endpoint](#input\_private\_dynamodb\_endpoint) | Deploy a DynamoDB endpoint for your private subnets | `bool` | `false` | no |
| <a name="input_private_s3_endpoint"></a> [private\_s3\_endpoint](#input\_private\_s3\_endpoint) | Deploy an S3 endpoint for your private subnets | `bool` | `false` | no |
| <a name="input_private_subnet_bits"></a> [private\_subnet\_bits](#input\_private\_subnet\_bits) | The number of bits used for the subnet mask | `number` | `null` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Additional tags to set on the private subnets | `map(string)` | `{}` | no |
| <a name="input_public_subnet_bits"></a> [public\_subnet\_bits](#input\_public\_subnet\_bits) | The number of bits used for the subnet mask | `number` | `null` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Additional tags to set on the public subnets | `map(string)` | `{}` | no |
| <a name="input_restrict_default_security_group"></a> [restrict\_default\_security\_group](#input\_restrict\_default\_security\_group) | Set to true to remove all rules from the default security group | `bool` | `true` | no |
| <a name="input_s3_interface_endpoint"></a> [s3\_interface\_endpoint](#input\_s3\_interface\_endpoint) | Variables to provision an S3 interface endpoint to the VPC | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |
| <a name="input_s3_route_table_ids"></a> [s3\_route\_table\_ids](#input\_s3\_route\_table\_ids) | Custom route table IDs for the S3 endpoint | `list(string)` | `null` | no |
| <a name="input_share_private_subnets"></a> [share\_private\_subnets](#input\_share\_private\_subnets) | If set it will share the private subnets through resource access manager | `bool` | `false` | no |
| <a name="input_share_public_subnets"></a> [share\_public\_subnets](#input\_share\_public\_subnets) | If set it will share the public subnets through resource access manager | `bool` | `false` | no |
| <a name="input_shared_public_route_table"></a> [shared\_public\_route\_table](#input\_shared\_public\_route\_table) | Determines weather to use a single route table for all public networks | `bool` | `true` | no |
| <a name="input_ssm_endpoint"></a> [ssm\_endpoint](#input\_ssm\_endpoint) | Variables to provision an SSM endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ssmmessages_endpoint"></a> [ssmmessages\_endpoint](#input\_ssmmessages\_endpoint) | Variables to provision an SSM messages endpoint to the VPC | <pre>object({<br>    private_dns_enabled = bool<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>  })</pre> | `null` | no |
| <a name="input_subnet_sharing_custom_tags"></a> [subnet\_sharing\_custom\_tags](#input\_subnet\_sharing\_custom\_tags) | Custom tags to be added to a resource share for subnets | `map(string)` | `{}` | no |
| <a name="input_transfer_server"></a> [transfer\_server](#input\_transfer\_server) | Variables to provision a Transfer Server endpoint to the VPC | <pre>object({<br>    security_group_ids  = list(string)<br>    subnet_ids          = list(string)<br>    private_dns_enabled = bool<br>  })</pre> | `null` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags to set on the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | CIDR block of the VPC |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPC |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | ID of the Internet Gateway |
| <a name="output_lambda_route_table_ids"></a> [lambda\_route\_table\_ids](#output\_lambda\_route\_table\_ids) | IDs of the Lambda route tables |
| <a name="output_lambda_subnet_arns"></a> [lambda\_subnet\_arns](#output\_lambda\_subnet\_arns) | ARNs of the Lambda subnets |
| <a name="output_lambda_subnet_cidr_blocks"></a> [lambda\_subnet\_cidr\_blocks](#output\_lambda\_subnet\_cidr\_blocks) | CIDR blocks of the Lambda subnets |
| <a name="output_lambda_subnet_ids"></a> [lambda\_subnet\_ids](#output\_lambda\_subnet\_ids) | IDs of the Lambda subnets |
| <a name="output_name"></a> [name](#output\_name) | The name provided for the VPC |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | IDs of the NAT gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | IDs of the private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | ARNs of the private subnets |
| <a name="output_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#output\_private\_subnet\_cidr\_blocks) | CIDR blocks of the private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of the private subnets |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID of the single public route table when a shared public route table is used |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | IDs of the public route tables when a shared public route table is not used |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | ARNs of the public subnets |
| <a name="output_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#output\_public\_subnet\_cidr\_blocks) | CIDR blocks of the public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of the public subnets |
| <a name="output_subnet_share_arn"></a> [subnet\_share\_arn](#output\_subnet\_share\_arn) | The ARN of the subnet share in resource access manager if any |
| <a name="output_subnet_share_id"></a> [subnet\_share\_id](#output\_subnet\_share\_id) | The ID of the subnet share in resource access manager if any |
| <a name="output_vpc_endpoint_ids"></a> [vpc\_endpoint\_ids](#output\_vpc\_endpoint\_ids) | An object containing the ID of each created VPC endpoint |
<!-- END_TF_DOCS -->