module "subnet_sharing" {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-subnet-sharing?ref=v0.2.0"
  count                 = var.share_public_subnets || var.share_private_subnets ? 1 : 0
  name                  = var.name
  prepend_resource_type = var.prepend_resource_type
  private_subnet_arns   = var.share_private_subnets ? toset(aws_subnet.private[*].arn) : []
  public_subnet_arns    = var.share_public_subnets ? toset(aws_subnet.public[*].arn) : []
  tags                  = merge(var.tags, var.subnet_sharing_custom_tags)
}
