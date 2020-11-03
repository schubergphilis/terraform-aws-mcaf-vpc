resource "aws_ram_resource_share" "subnet_sharing" {
  count                     = var.share_public_subnets || var.share_private_subnets ? 1 : 0
  name                      = "${var.prepend_resource_type ? "resource-share-" : ""}subnets-${var.name}"
  allow_external_principals = true
  tags = merge(
    { "environment" = var.name, "resource-type" = "ec2:Subnet" },
    var.subnet_sharing_custom_tags
  )
}

resource "aws_ram_resource_association" "private_subnets" {
  for_each           = var.share_private_subnets ? toset(aws_subnet.private[*].arn) : []
  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.subnet_sharing[0].arn
}

resource "aws_ram_resource_association" "public_subnets" {
  for_each           = var.share_public_subnets ? toset(aws_subnet.public[*].arn) : []
  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.subnet_sharing[0].arn
}