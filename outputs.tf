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

output "ec2_endpoint_security_group_ids" {
  value = length(var.ec2_endpoint.security_group_ids) == 0 ? aws_security_group.ec2_endpoint.*.id : var.ec2_endpoint.security_group_ids
}

output "ec2messages_endpoint_security_group_ids" {
  value = length(var.ec2messages_endpoint.security_group_ids) == 0 ? aws_security_group.ec2messages_endpoint.*.id : var.ec2messages_endpoint.security_group_ids
}

output "ssm_endpoint_security_group_ids" {
  value = length(var.ssm_endpoint.security_group_ids) == 0 ? aws_security_group.ssm_endpoint.*.id : var.ssm_endpoint.security_group_ids
}

output "ssmmessages_endpoint_security_group_ids" {
  value = length(var.ssmmessages_endpoint.security_group_ids) == 0 ? aws_security_group.ssmmessages_endpoint.*.id : var.ssmmessages_endpoint.security_group_ids
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
  value       = aws_route_table.public[*].id
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
