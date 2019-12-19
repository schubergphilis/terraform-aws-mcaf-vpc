data "aws_vpc_endpoint_service" "transfer_server" {
  count   = var.transfer_endpoint != null ? 1 : 0
  service = "transfer.server"
}

resource "aws_vpc_endpoint" "transfer_server" {
  count               = var.transfer_endpoint != null ? 1 : 0
  private_dns_enabled = var.transfer_endpoint.private_dns_enabled
  security_group_ids  = var.transfer_endpoint.security_group_ids
  service_name        = data.aws_vpc_endpoint_service.transfer_server[0].service_name
  subnet_ids          = var.transfer_endpoint.subnet_ids
  tags                = merge(var.tags, { "Name" = "${var.stack}-transfer-server" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id
}
