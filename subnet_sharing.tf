locals {
  sharing_private_subnet_arns = var.share_private_subnets ? aws_subnet.private[*].arn : []
  sharing_public_subnet_arns  = var.share_public_subnets ? aws_subnet.public[*].arn : []

  sharing_tags = merge(var.tags, var.subnet_sharing_custom_tags)
}

resource "aws_ram_resource_share" "subnet_sharing" {
  count = var.share_public_subnets || var.share_private_subnets ? 1 : 0

  name                      = "${var.prepend_resource_type ? "resource-share-" : ""}subnets-${var.name}"
  allow_external_principals = true
  tags                      = local.sharing_tags
}

resource "aws_ram_resource_association" "private_subnets" {
  count = length(local.sharing_private_subnet_arns)

  resource_arn       = local.sharing_private_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.subnet_sharing[0].arn
}

resource "aws_ram_resource_association" "public_subnets" {
  count = length(local.sharing_public_subnet_arns)

  resource_arn       = local.sharing_public_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.subnet_sharing[0].arn
}
