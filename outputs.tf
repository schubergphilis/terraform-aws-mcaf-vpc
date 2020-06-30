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

output "sgp_ssm_endpoint_id" {
  value = aws_security_group.sgp_ssm_endpoint.*.id
}

output "sgp_ec2messages_endpoint_id" {
  value = aws_security_group.sgp_ec2messages_endpoint.*.id
}

output "sgp_ec2_endpoint_id" {
  value = aws_security_group.sgp_ec2_endpoint.*.id
}

output "sgp_ssmmessages_endpoint_id" {
  value = aws_security_group.sgp_ssmmessages_endpoint.*.id
}
