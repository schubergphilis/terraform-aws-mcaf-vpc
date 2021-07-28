output "id" {
  value       = aws_vpc.default.id
  description = "ID of the VPC"
}

output "cidr_block" {
  value       = aws_vpc.default.cidr_block
  description = "CIDR block of the VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.default[*].id
  description = "ID of the Internet Gateway"
}

output "name" {
  value       = var.name
  description = "The name provided for the VPC"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.default[*].id
  description = "IDs of the NAT gateways"
}

output "lambda_subnet_ids" {
  value       = aws_subnet.lambda[*].id
  description = "IDs of the Lambda subnets"
}

output "lambda_subnet_arns" {
  value       = aws_subnet.lambda[*].arn
  description = "ARNs of the Lambda subnets"
}

output "lambda_subnet_cidr_blocks" {
  value       = aws_subnet.lambda[*].cidr_block
  description = "CIDR blocks of the Lambda subnets"
}

output "lambda_route_table_ids" {
  value       = aws_route_table.lambda[*].id
  description = "IDs of the Lambda route tables"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of the public subnets"
}

output "public_subnet_arns" {
  value       = aws_subnet.public[*].arn
  description = "ARNs of the public subnets"
}

output "public_subnet_cidr_blocks" {
  value       = aws_subnet.public[*].cidr_block
  description = "CIDR blocks of the public subnets"
}

output "public_route_table_id" {
  value       = try(aws_route_table.public.0.id, null)
  description = "ID of the public route table"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of the private subnets"
}

output "private_subnet_arns" {
  value       = aws_subnet.private[*].arn
  description = "ARNs of the private subnets"
}

output "private_subnet_cidr_blocks" {
  value       = aws_subnet.private[*].cidr_block
  description = "CIDR blocks of the private subnets"
}

output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
  description = "IDs of the private route tables"
}

output "subnet_share_id" {
  value       = try(module.subnet_sharing[0].id, null)
  description = "The ID of the subnet share in resource access manager if any"
}

output "subnet_share_arn" {
  value       = try(module.subnet_sharing[0].arn, null)
  description = "The ARN of the subnet share in resource access manager if any"
}

output "vpc_endpoint_ids" {
  value = {
    dkr         = try(aws_vpc_endpoint.ecr_dkr_endpoint[0].id, null)
    dynamodb    = try(aws_vpc_endpoint.dynamodb[0].id, null)
    ec2         = try(aws_vpc_endpoint.ssmmessages_endpoint[0].id, null)
    ecr         = try(aws_vpc_endpoint.ecr_api_endpoint[0].id, null)
    ec2messages = try(aws_vpc_endpoint.ec2messages_endpoint[0].id, null)
    logs        = try(aws_vpc_endpoint.logs_endpoint[0].id, null)
    s3          = try(aws_vpc_endpoint.s3[0].id, null)
    ssm         = try(aws_vpc_endpoint.ssm_endpoint[0].id, null)
    ssmmessages = try(aws_vpc_endpoint.ec2_endpoint[0].id, null)
  }
  description = "An object containing the ID of each created VPC endpoint"
}
