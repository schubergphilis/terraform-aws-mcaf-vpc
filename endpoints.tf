locals {
  s3_route_table_ids = var.s3_route_table_ids != null ? var.s3_route_table_ids : aws_route_table.private[*].id
}

# Resources for the DynamoDB VPC service endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.private_dynamodb_endpoint ? 1 : 0
  route_table_ids   = aws_route_table.private[*].id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}dynamodb-${var.name}" })
}

# Resources for the EBS VPC interface endpoint
data "aws_vpc_endpoint_service" "ebs_endpoint" {
  count   = var.ebs_endpoint != null ? 1 : 0
  service = "ebs"
}

resource "aws_vpc_endpoint" "ebs_endpoint" {
  count               = var.ebs_endpoint != null ? 1 : 0
  private_dns_enabled = var.ebs_endpoint.private_dns_enabled
  security_group_ids  = var.ebs_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ebs_endpoint[0].service_name
  subnet_ids          = var.ebs_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ebs-${var.name}" })
}


# Resources for the EC2 VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2_endpoint" {
  count   = var.ec2_endpoint != null ? 1 : 0
  service = "ec2"
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  count               = var.ec2_endpoint != null ? 1 : 0
  private_dns_enabled = var.ec2_endpoint.private_dns_enabled
  security_group_ids  = var.ec2_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2_endpoint[0].service_name
  subnet_ids          = var.ec2_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ec2-${var.name}" })
}

# Resources for the EC2 messages VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2messages_endpoint" {
  count   = var.ec2messages_endpoint != null ? 1 : 0
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
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ec2messages-${var.name}" })
}

# Resources for the ECR VPC interface endpoint
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  count               = var.ecr_api_endpoint != null ? 1 : 0
  private_dns_enabled = var.ecr_api_endpoint.private_dns_enabled
  security_group_ids  = var.ecr_api_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  subnet_ids          = var.ecr_api_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ecr-${var.name}" })
}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  count               = var.ecr_api_endpoint != null ? 1 : 0
  private_dns_enabled = var.ecr_api_endpoint.private_dns_enabled
  security_group_ids  = var.ecr_api_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  subnet_ids          = var.ecr_api_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ecr-${var.name}" })
}

# Resources for logs VPC interface endpoint
resource "aws_vpc_endpoint" "logs_endpoint" {
  count               = var.logs_endpoint != null ? 1 : 0
  private_dns_enabled = var.logs_endpoint.private_dns_enabled
  security_group_ids  = var.logs_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  subnet_ids          = var.logs_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}logs-${var.name}" })
}

# Resources for the S3 VPC service endpoint
resource "aws_vpc_endpoint" "s3" {
  count             = var.private_s3_endpoint ? 1 : 0
  route_table_ids   = local.s3_route_table_ids
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}s3-${var.name}" })
}

# Resources for the SSM VPC interface endpoint
data "aws_vpc_endpoint_service" "ssm_endpoint" {
  count   = var.ssm_endpoint != null ? 1 : 0
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  count               = var.ssm_endpoint != null ? 1 : 0
  private_dns_enabled = var.ssm_endpoint.private_dns_enabled
  security_group_ids  = var.ssm_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssm_endpoint[0].service_name
  subnet_ids          = var.ssm_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ssm-${var.name}" })
}

# Resources for the SSM messages VPC interface endpoint
data "aws_vpc_endpoint_service" "ssmmessages_endpoint" {
  count   = var.ssmmessages_endpoint != null ? 1 : 0
  service = "ssmmessages"
}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  count               = var.ssmmessages_endpoint != null ? 1 : 0
  private_dns_enabled = var.ssmmessages_endpoint.private_dns_enabled
  security_group_ids  = var.ssmmessages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssmmessages_endpoint[0].service_name
  subnet_ids          = var.ssmmessages_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}ssmmessages-${var.name}" })
}

# Resources for the Transfer Server VPC interface endpoint
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
  tags                = merge(var.tags, { "Name" = "${var.prepend_resource_type ? "endpoint-" : ""}transfer-server-${var.name}" })
}
