locals {
  az_ids          = [for zone in var.availability_zones : substr(zone, length(zone) - 1, 1)]
  should_lambda   = var.lambda_subnets ? 1 : 0
  should_private  = var.private_subnets ? 1 : 0
  should_public   = var.public_subnets ? 1 : 0
  lambda_subnets  = local.should_lambda * local.zones
  private_subnets = local.should_private * local.zones
  public_subnets  = local.should_public * local.zones
  vpc_subnet_bits = parseint(regex("\\/(\\d{1,2})$", var.cidr_block)[0], 10)
  zones           = length(var.availability_zones)

  # Calculate the newbits as used by the cidrsubnets function.
  # https://www.terraform.io/docs/configuration/functions/cidrsubnets.html
  private_newbits = local.should_private == 0 ? [] : [for zone in var.availability_zones : var.private_subnet_bits - local.vpc_subnet_bits]
  public_newbits = local.should_public == 0 ? [] : [for zone in var.availability_zones : var.public_subnet_bits - local.vpc_subnet_bits]
  lambda_newbits = local.should_lambda == 0 ? [] : [for zone in var.availability_zones : var.lambda_subnet_bits - local.vpc_subnet_bits]

  # Build a list of newbits for all the needed subnets.
  # The "formatlist" is needed to work around a Terraform bug:
  # https://github.com/hashicorp/terraform/issues/22404
  newbits = formatlist("%d", concat(local.public_newbits, local.private_newbits, local.lambda_newbits))

  # If you have a crash when calculating the subnets, please refer to:
  # https://github.com/hashicorp/terraform/issues/23841
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
  count  = local.should_public
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "${var.stack}-igw" })
}

resource "aws_eip" "nat" {
  count = local.public_subnets
  vpc   = true

  tags = merge(
    var.tags, { "Name" = "${var.stack}-nat-${local.az_ids[count.index]}" }
  )

  depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "default" {
  count         = local.public_subnets
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-nat-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "public" {
  count                   = local.public_subnets
  cidr_block              = local.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-public-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "private" {
  count                   = local.private_subnets
  cidr_block              = local.cidr_blocks[local.public_subnets + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-private-${local.az_ids[count.index]}" }
  )
}

resource "aws_subnet" "lambda" {
  count                   = local.lambda_subnets
  cidr_block              = local.cidr_blocks[local.public_subnets + local.private_subnets + count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.default.id

  tags = merge(
    var.tags, { "Name" = "${var.stack}-lambda-${local.az_ids[count.index]}" }
  )
}

resource "aws_route_table" "public" {
  count  = local.should_public
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { "Name" = "${var.stack}-public" })
}

resource "aws_route" "public" {
  count                  = local.should_public
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
    var.tags, { "Name" = "${var.stack}-private-${local.az_ids[count.index]}" }
  )
}

resource "aws_route" "private" {
  count                  = local.should_private > 0 && local.should_public > 0 ? local.private_subnets : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.should_private > 0 && local.should_public > 0 ? local.private_subnets : 0
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
  count                  = local.should_lambda > 0 && local.should_public > 0 ? local.lambda_subnets : 0
  route_table_id         = aws_route_table.lambda[count.index].id
  destination_cidr_block = local.should_public == 0 ? null : "0.0.0.0/0"
  nat_gateway_id         = local.should_public == 0 ? null : aws_nat_gateway.default[count.index].id
}

resource "aws_route_table_association" "lambda" {
  count          = local.should_lambda > 0 && local.should_public > 0 ? local.lambda_subnets : 0
  subnet_id      = aws_subnet.lambda[count.index].id
  route_table_id = aws_route_table.lambda[count.index].id
}
