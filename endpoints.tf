# Resources for the transfer_server VPC interface endpoint
data "aws_vpc_endpoint_service" "transfer_server" {
  count   = var.transfer_server != null ? 1 : 0
  service = "transfer.server"
}

resource "aws_vpc_endpoint" "transfer_server" {
  count               = var.transfer_server != null ? 1 : 0
  private_dns_enabled = var.transfer_server.private_dns_enabled
  security_group_ids  = var.transfer_server.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.transfer_server[0].service_name
  subnet_ids          = var.transfer_server.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "transfer-server-${var.name}" })
}

# Resources for the s3 VPC service endpoint
resource "aws_vpc_endpoint" "s3" {
  count             = var.private_s3_endpoint != false ? 1 : 0
  route_table_ids   = aws_route_table.private[*].id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, { "Name" = "s3-vpc-endpoint-${var.name}" })
}

# Resources for the ssm VPC interface endpoint
data "aws_vpc_endpoint_service" "ssm_endpoint" {
  count   = var.ssm_endpoint.subnet_ids != null ? 1 : 0
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  count               = var.ssm_endpoint.subnet_ids != null ? 1 : 0
  private_dns_enabled = var.ssm_endpoint.private_dns_enabled
  security_group_ids  = var.ssm_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssm_endpoint[0].service_name
  subnet_ids          = var.ssm_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ssm-endpoint-${var.name}" })
}

# Resources for the ec2messages VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2messages_endpoint" {
  count   = var.ec2messages_endpoint.subnet_ids != null ? 1 : 0
  service = "ec2messages"
}

resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  count               = var.ec2messages_endpoint != null ? 1 : 0
  private_dns_enabled = var.ec2messages_endpoint.private_dns_enabled
  security_group_ids  = var.ec2messages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2messages_endpoint[0].service_name
  subnet_ids          = var.ec2messages_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ec2messages-endpoint-${var.name}" })
}

# Resources for the ec2 VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2_endpoint" {
  count   = var.ec2_endpoint.subnet_ids != null ? 1 : 0
  service = "ec2"
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  count               = var.ec2_endpoint.subnet_ids != null ? 1 : 0
  private_dns_enabled = var.ec2_endpoint.private_dns_enabled
  security_group_ids  = var.ec2_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2_endpoint[0].service_name
  subnet_ids          = var.ec2_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ec2-endpoint-${var.name}" })
}

# Resources for the ssmmessages VPC interface endpoint
data "aws_vpc_endpoint_service" "ssmmessages_endpoint" {
  count   = var.ssmmessages_endpoint != null ? 1 : 0
  service = "ssmmessages"
}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  count               = var.ssmmessages_endpoint.subnet_ids != null ? 1 : 0
  private_dns_enabled = var.ssmmessages_endpoint.private_dns_enabled
  security_group_ids  = var.ssmmessages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssmmessages_endpoint[0].service_name
  subnet_ids          = var.ssmmessages_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ssmmessages-endpoint-${var.name}" })
}
