locals {
  s3_route_table_ids = var.s3_route_table_ids != null ? var.s3_route_table_ids : aws_route_table.private[*].id
}

# Resources for the CodeBuild VPC interface endpoint
resource "aws_vpc_endpoint" "codebuild_interface_endpoint" {
  count = var.codebuild_interface_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.codebuild_interface_endpoint.private_dns_enabled
  security_group_ids  = var.codebuild_interface_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.codebuild"
  subnet_ids          = var.codebuild_interface_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "codebuild-interface-${var.name}" })
}

# Resources for the DynamoDB VPC service endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.private_dynamodb_endpoint ? 1 : 0

  region            = var.region
  route_table_ids   = aws_route_table.private[*].id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, { "Name" = "dynamodb-${var.name}" })
}

# Resources for the EBS VPC interface endpoint
data "aws_vpc_endpoint_service" "ebs_endpoint" {
  count   = var.ebs_endpoint != null ? 1 : 0
  service = "ebs"
}

resource "aws_vpc_endpoint" "ebs_endpoint" {
  count = var.ebs_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ebs_endpoint.private_dns_enabled
  security_group_ids  = var.ebs_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ebs_endpoint[0].service_name
  subnet_ids          = var.ebs_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ebs-${var.name}" })
}


# Resources for the EC2 VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2_endpoint" {
  count   = var.ec2_endpoint != null ? 1 : 0
  service = "ec2"
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  count = var.ec2_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ec2_endpoint.private_dns_enabled
  security_group_ids  = var.ec2_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2_endpoint[0].service_name
  subnet_ids          = var.ec2_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ec2-${var.name}" })
}

# Resources for the EC2 messages VPC interface endpoint
data "aws_vpc_endpoint_service" "ec2messages_endpoint" {
  count   = var.ec2messages_endpoint != null ? 1 : 0
  service = "ec2messages"
}

resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  count = var.ec2messages_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ec2messages_endpoint.private_dns_enabled
  security_group_ids  = var.ec2messages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ec2messages_endpoint[0].service_name
  subnet_ids          = var.ec2messages_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ec2messages-${var.name}" })
}

# Resources for the ECR VPC interface endpoint
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  count = var.ecr_api_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ecr_api_endpoint.private_dns_enabled
  security_group_ids  = var.ecr_api_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  subnet_ids          = var.ecr_api_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ecr-${var.name}" })
}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  count = var.ecr_api_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ecr_api_endpoint.private_dns_enabled
  security_group_ids  = var.ecr_api_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  subnet_ids          = var.ecr_api_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ecr-${var.name}" })
}

# Resources for logs VPC interface endpoint
resource "aws_vpc_endpoint" "logs_endpoint" {
  count = var.logs_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.logs_endpoint.private_dns_enabled
  security_group_ids  = var.logs_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.logs"
  subnet_ids          = var.logs_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "logs-${var.name}" })
}

# Resources for the MGN VPC interface endpoint
resource "aws_vpc_endpoint" "mgn_endpoint" {
  count = var.mgn_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.mgn_endpoint.private_dns_enabled
  security_group_ids  = var.mgn_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.mgn"
  subnet_ids          = var.mgn_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "mgn-${var.name}" })
}

# Resources for the S3 VPC service endpoint
resource "aws_vpc_endpoint" "s3" {
  count = var.private_s3_endpoint ? 1 : 0

  region            = var.region
  route_table_ids   = local.s3_route_table_ids
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, { "Name" = "s3-${var.name}" })
}

# Resources for the S3 VPC interface endpoint
resource "aws_vpc_endpoint" "s3_interface_endpoint" {
  count = var.s3_interface_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = false
  security_group_ids  = var.s3_interface_endpoint.security_group_ids
  service_name        = "com.amazonaws.${data.aws_region.current.region}.s3"
  subnet_ids          = var.s3_interface_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "s3-interface-${var.name}" })
}

# Resources for the SSM VPC interface endpoint
data "aws_vpc_endpoint_service" "ssm_endpoint" {
  count   = var.ssm_endpoint != null ? 1 : 0
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  count = var.ssm_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ssm_endpoint.private_dns_enabled
  security_group_ids  = var.ssm_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssm_endpoint[0].service_name
  subnet_ids          = var.ssm_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ssm-${var.name}" })
}

# Resources for the SSM messages VPC interface endpoint
data "aws_vpc_endpoint_service" "ssmmessages_endpoint" {
  count   = var.ssmmessages_endpoint != null ? 1 : 0
  service = "ssmmessages"
}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  count = var.ssmmessages_endpoint != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.ssmmessages_endpoint.private_dns_enabled
  security_group_ids  = var.ssmmessages_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.ssmmessages_endpoint[0].service_name
  subnet_ids          = var.ssmmessages_endpoint.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "ssmmessages-${var.name}" })
}

# Resources for the Transfer Server VPC interface endpoint
data "aws_vpc_endpoint_service" "transfer_server" {
  count   = var.transfer_server != null ? 1 : 0
  service = "transfer.server"
}

resource "aws_vpc_endpoint" "transfer_server" {
  count = var.transfer_server != null ? 1 : 0

  region              = var.region
  private_dns_enabled = var.transfer_server.private_dns_enabled
  security_group_ids  = var.transfer_server.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.transfer_server[0].service_name
  subnet_ids          = var.transfer_server.subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
  tags                = merge(var.tags, { "Name" = "transfer-server-${var.name}" })
}
