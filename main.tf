locals {
  az_ids          = [for zone in var.availability_zones : substr(zone, length(zone) - 1, 1)]
  vpc_subnet_bits = parseint(regex("\\/(\\d{1,2})$", var.cidr_block)[0], 10)

  # Determine how many of each type of subnet we want to create.
  public_subnets  = var.public_subnet_bits != null ? length(var.availability_zones) : 0
  private_subnets = var.private_subnet_bits != null ? length(var.availability_zones) : 0
  lambda_subnets  = var.lambda_subnet_bits != null ? length(var.availability_zones) : 0

  # Calculate the newbits as used by the cidrsubnets function.
  # https://www.terraform.io/docs/configuration/functions/cidrsubnets.html
  public_newbits  = local.public_subnets > 0 ? var.public_subnet_bits - local.vpc_subnet_bits : null
  private_newbits = local.private_subnets > 0 ? var.private_subnet_bits - local.vpc_subnet_bits : null
  lambda_newbits  = local.lambda_subnets > 0 ? var.lambda_subnet_bits - local.vpc_subnet_bits : null

  # Build a list of newbits for all the needed subnets.
  # The "formatlist" is needed to work around a Terraform bug:
  # https://github.com/hashicorp/terraform/issues/22404
  newbits = concat(
    formatlist("%d", [for subnet in range(local.public_subnets) : local.public_newbits]),
    formatlist("%d", [for subnet in range(local.private_subnets) : local.private_newbits]),
    formatlist("%d", [for subnet in range(local.lambda_subnets) : local.lambda_newbits]),
  )

  # If you have a crash when calculating the subnets, please refer to:
  # https://github.com/hashicorp/terraform/issues/23841
  cidr_blocks = cidrsubnets(var.cidr_block, local.newbits...)
}

data "aws_region" "current" {}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags                 = merge(var.tags, { "Name" = "vpc-${var.name}" })
}

resource "aws_internet_gateway" "default" {
  count  = min(local.public_subnets, 1)
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "igw-${var.name}" })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? local.public_subnets : 0
  vpc   = true

  tags = merge(
    var.tags, { "Name" = "eip-nat-${var.name}-${local.az_ids[count.index]}" }
  )

  depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "default" {
  count         = var.enable_nat_gateway ? local.public_subnets : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags, { "Name" = "nat-${var.name}-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "public" {
  count                   = local.public_subnets
  cidr_block              = local.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    { "Name" = "subnet-${var.name}-public-${local.az_ids[count.index]}" },
    var.public_subnet_tags,
    var.tags
  )
}

resource "aws_subnet" "private" {
  count                   = local.private_subnets
  cidr_block              = local.cidr_blocks[local.public_subnets + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    { "Name" = "subnet-${var.name}-private-${local.az_ids[count.index]}" },
    var.private_subnet_tags,
    var.tags
  )
}

resource "aws_subnet" "lambda" {
  count                   = local.lambda_subnets
  cidr_block              = local.cidr_blocks[local.public_subnets + local.private_subnets + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "lambda-${var.name}-${local.az_ids[count.index]}" }
  )
}

resource "aws_route_table" "public" {
  count  = min(local.public_subnets, 1)
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "route-table-${var.name}-public" })
}

resource "aws_route" "public" {
  count                  = min(local.public_subnets, 1)
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default[0].id
}

resource "aws_route_table_association" "public" {
  count          = local.public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count  = local.private_subnets
  vpc_id = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "route-table-${var.name}-private-${local.az_ids[count.index]}" }
  )
}

resource "aws_route" "private" {
  count                  = var.enable_nat_gateway && local.private_subnets > 0 && local.public_subnets > 0 ? local.private_subnets : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "lambda" {
  count  = local.lambda_subnets
  vpc_id = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "route-table-${var.name}-lambda-${local.az_ids[count.index]}" }
  )
}

resource "aws_route" "lambda" {
  count                  = var.enable_nat_gateway && local.lambda_subnets > 0 && local.public_subnets > 0 ? local.lambda_subnets : 0
  route_table_id         = aws_route_table.lambda[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "lambda" {
  count          = local.lambda_subnets
  subnet_id      = aws_subnet.lambda[count.index].id
  route_table_id = aws_route_table.lambda[count.index].id
}
