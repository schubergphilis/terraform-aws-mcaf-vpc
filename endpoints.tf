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
  tags                = merge(var.tags, { "Name" = "transfer-server-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}


data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  count             = var.private_s3_endpoint != false ? 1 : 0
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  tags              = merge(var.tags, { "Name" = "s3-vpc-endpoint-${var.name}" })
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  route_table_ids   = aws_route_table.private[*].id
}

data "aws_vpc_endpoint_service" "ssm_endpoint" {
  count   = length(var.ssm_endpoint.subnet_ids) != 0 ? 1 : 0
  service = "ssm"
}

resource "aws_security_group" "sgp_ssm_endpoint" {
  count  = length(var.ssm_endpoint.security_group_ids) == 0 ? 1 : 0
  vpc_id = aws_vpc.default.id
  name   = "sgp-ssm-endpoint-${var.name}"
  tags   = { Name = "sgp-ssm-endpoint-${var.name}" }
}

resource "aws_security_group_rule" "sgr_ssm_endpoint" {
  count             = length(var.ssm_endpoint.security_group_ids) == 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.default.cidr_block]
  security_group_id = aws_security_group.sgp_ssm_endpoint[0].id
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  count               = length(var.ssm_endpoint.subnet_ids) != 0 ? 1 : 0
  private_dns_enabled = var.ssm_endpoint.private_dns_enabled
  security_group_ids  = length(var.ssm_endpoint.security_group_ids) == 0 ? [aws_security_group.sgp_ssm_endpoint[count.index].id] : var.ssm_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssm_endpoint[0].service_name
  subnet_ids          = var.ssm_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "ssm-endpoint-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}

data "aws_vpc_endpoint_service" "ec2messages_endpoint" {
  count   = length(var.ec2messages_endpoint.subnet_ids) != 0 ? 1 : 0
  service = "ec2messages"
}

resource "aws_security_group" "sgp_ec2messages_endpoint" {
  count  = length(var.ec2messages_endpoint.security_group_ids) == 0 ? 1 : 0
  vpc_id = aws_vpc.default.id
  name   = "sgp-ec2messages-endpoint-${var.name}"
  tags   = { Name = "sgp-ec2messages-endpoint-${var.name}" }
}

resource "aws_security_group_rule" "sgr_ec2messages_endpoint" {
  count             = length(var.ec2messages_endpoint.security_group_ids) == 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.default.cidr_block]
  security_group_id = aws_security_group.sgp_ec2messages_endpoint[0].id
}

resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  count               = length(var.ec2messages_endpoint) != 0 ? 1 : 0
  private_dns_enabled = var.ec2messages_endpoint.private_dns_enabled
  security_group_ids  = length(var.ec2messages_endpoint.security_group_ids) == 0 ? [aws_security_group.sgp_ec2messages_endpoint[count.index].id] : var.ec2messages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2messages_endpoint[0].service_name
  subnet_ids          = var.ec2messages_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "ec2messages-endpoint-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}

data "aws_vpc_endpoint_service" "ec2_endpoint" {
  count   = length(var.ec2_endpoint.subnet_ids) != 0 ? 1 : 0
  service = "ec2"
}

resource "aws_security_group" "sgp_ec2_endpoint" {
  count  = length(var.ec2_endpoint.security_group_ids) == 0 ? 1 : 0
  vpc_id = aws_vpc.default.id
  name   = "sgp-ec2-endpoint-${var.name}"
  tags   = { Name = "sgp-ec2-endpoint-${var.name}" }
}

resource "aws_security_group_rule" "sgr_ec2_endpoint" {
  count             = length(var.ec2_endpoint.security_group_ids) == 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.default.cidr_block]
  security_group_id = aws_security_group.sgp_ec2_endpoint[0].id
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  count               = length(var.ec2_endpoint.subnet_ids) != 0 ? 1 : 0
  private_dns_enabled = var.ec2_endpoint.private_dns_enabled
  security_group_ids  = length(var.ec2_endpoint.security_group_ids) == 0 ? [aws_security_group.sgp_ec2_endpoint[count.index].id] : var.ec2_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2_endpoint[0].service_name
  subnet_ids          = var.ec2_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "ec2-endpoint-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}

data "aws_vpc_endpoint_service" "ssmmessages_endpoint" {
  count   = length(var.ssmmessages_endpoint.subnet_ids) != 0 ? 1 : 0
  service = "ssmmessages"
}

resource "aws_security_group" "sgp_ssmmessages_endpoint" {
  count  = length(var.ssmmessages_endpoint.security_group_ids) == 0 ? 1 : 0
  vpc_id = aws_vpc.default.id
  name   = "sgp-ssmmessages-endpoint-${var.name}"
  tags   = { Name = "sgp-ssmmessages-endpoint-${var.name}" }
}

resource "aws_security_group_rule" "sgr_ssmmessages_endpoint" {
  count             = length(var.ssmmessages_endpoint.security_group_ids) == 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.default.cidr_block]
  security_group_id = aws_security_group.sgp_ssmmessages_endpoint[0].id
}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  count               = length(var.ssmmessages_endpoint.subnet_ids) != 0 ? 1 : 0
  private_dns_enabled = var.ssmmessages_endpoint.private_dns_enabled
  security_group_ids  = length(var.ssmmessages_endpoint.security_group_ids) == 0 ? [aws_security_group.sgp_ssmmessages_endpoint[count.index].id] : var.ssmmessages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssmmessages_endpoint[0].service_name
  subnet_ids          = var.ssmmessages_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "ssmmessages-endpoint-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}
