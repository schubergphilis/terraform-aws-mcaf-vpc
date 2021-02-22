resource "aws_vpc_dhcp_options" "default" {
  count                = var.dhcp_options != null ? 1 : 0
  domain_name          = var.dhcp_options.domain_name
  domain_name_servers  = var.dhcp_options.domain_name_servers
  ntp_servers          = var.dhcp_options.ntp_servers
  netbios_name_servers = var.dhcp_options.netbios_name_servers
  netbios_node_type    = var.dhcp_options.netbios_node_type
  tags                 = var.dhcp_options.tags
}

resource "aws_vpc_dhcp_options_association" "default" {
  count           = var.dhcp_options != null ? 1 : 0
  vpc_id          = aws_vpc.default.id
  dhcp_options_id = aws_vpc_dhcp_options.default[0].id
}
