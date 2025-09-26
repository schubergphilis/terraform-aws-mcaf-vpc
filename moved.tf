moved {
  from = module.subnet_sharing[0].aws_ram_resource_share.subnet_sharing
  to   = aws_ram_resource_share.subnet_sharing[0]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.public_subnets[0]
  to   = aws_ram_resource_association.public_subnets[0]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.public_subnets[1]
  to   = aws_ram_resource_association.public_subnets[1]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.public_subnets[2]
  to   = aws_ram_resource_association.public_subnets[2]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.private_subnets[0]
  to   = aws_ram_resource_association.private_subnets[0]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.private_subnets[1]
  to   = aws_ram_resource_association.private_subnets[1]
}

moved {
  from = module.subnet_sharing[0].aws_ram_resource_association.private_subnets[2]
  to   = aws_ram_resource_association.private_subnets[2]
}
