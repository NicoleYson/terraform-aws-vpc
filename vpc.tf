resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = merge(
    var.vpc_tags,
    local.universal_tags,
    {
      "Name" = var.scope
    },
  )
}

data "aws_availability_zones" "available" {}
