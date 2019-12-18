data "aws_vpc_endpoint_service" "transferserver" {
  count   = var.transferserver_endpoint != null ? 1 : 0
  service = "transfer.server"
}

resource "aws_vpc_endpoint" "transferserver" {
  count               = var.transferserver_endpoint != null ? 1 : 0
  private_dns_enabled = var.transferserver_endpoint.private_dns_enabled
  security_group_ids  = var.transferserver_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.transferserver[0].service_name
  subnet_ids          = var.transferserver_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "${var.stack}-transferserver_endpoint" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}
