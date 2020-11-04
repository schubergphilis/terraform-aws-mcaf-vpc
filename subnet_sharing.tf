module "subnet_sharing" {
  source                = "git@git@github.com:schubergphilis/terraform-aws-mcaf-subnet-sharing.git?ref=v0.1.0"
  count                 = var.share_public_subnets || var.share_private_subnets ? 1 : 0
  name                  = var.name
  private_subnet_arns   = var.share_private_subnets ? toset(aws_subnet.private[*].arn) : []
  public_subnet_arns    = var.share_public_subnets ? toset(aws_subnet.public[*].arn) : []
  prepend_resource_type = var.prepend_resource_type
  tags                  = var.subnet_sharing_custom_tags
}
