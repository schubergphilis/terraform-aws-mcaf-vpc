locals {
  az_ids          = [for zone in var.availability_zones : substr(zone, length(zone) - 1, 1)]
  lambda_subnets  = var.lambda_subnets ? local.zones : 0
  vpc_subnet_bits = regex("\\/(\\d{1,2})$", var.cidr_block)[0]
  zones           = length(var.availability_zones)

  # Calculate the newbits as used by the cidrsubnets function.
  # https://www.terraform.io/docs/configuration/functions/cidrsubnets.html
  private_newbits = var.private_subnet_bits - local.vpc_subnet_bits
  public_newbits  = var.public_subnet_bits - local.vpc_subnet_bits
  lambda_newbits  = var.lambda_subnet_bits - local.vpc_subnet_bits

  # Build a list of newbits for all the needed subnets.
  # The "formatlist" is needed to work around a Terraform bug:
  # https://github.com/hashicorp/terraform/issues/22404
  newbits = concat(
    formatlist("%d", [for zone in var.availability_zones : local.public_newbits]),
    formatlist("%d", [for zone in var.availability_zones : local.private_newbits]),
    formatlist("%d", [for subnet in range(local.lambda_subnets) : local.lambda_newbits]),
  )

  cidr_blocks = cidrsubnets(var.cidr_block, local.newbits...)
}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags                 = merge(var.tags, { "Name" = "${var.stack}-vpc" })
}

resource "aws_internet_gateway" "default" {
  count  = var.private_only ? 0 : 1
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "${var.stack}-igw" })
}

resource "aws_eip" "nat" {
  count = var.private_only ? 0 : local.zones
  vpc   = true

  tags = merge(
    var.tags, { "Name" = "${var.stack}-nat-${local.az_ids[count.index]}" }
  )

  depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "default" {
  count         = var.private_only ? 0 : local.zones
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-nat-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "public" {
  count                   = var.private_only ? 0 : local.zones
  cidr_block              = local.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-public-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "private" {
  count                   = local.zones
  cidr_block              = local.cidr_blocks[local.zones + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-private-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "lambda" {
  count                   = local.lambda_subnets
  cidr_block              = local.cidr_blocks[local.zones + local.zones + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-lambda-${local.az_ids[count.index]}" }
  )
}

resource "aws_route_table" "public" {
  count  = var.private_only ? 0 : 1
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "${var.stack}-public" })
}

resource "aws_route" "public" {
  count                  = var.private_only ? 0 : 1
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default[0].id
}

resource "aws_route_table_association" "public" {
  count          = var.private_only ? 0 : local.zones
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count  = local.zones
  vpc_id = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-private-${local.az_ids[count.index]}" }
  )
}

resource "aws_route" "private" {
  count                  = var.private_only ? 0 : local.zones
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.zones
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "lambda" {
  count  = local.lambda_subnets
  vpc_id = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-lambda-${local.az_ids[count.index]}" }
  )
}

resource "aws_route" "lambda" {
  count                  = var.private_only ? 0 : local.lambda_subnets
  route_table_id         = aws_route_table.lambda[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "lambda" {
  count          = local.lambda_subnets
  subnet_id      = aws_subnet.lambda[count.index].id
  route_table_id = aws_route_table.lambda[count.index].id
}
