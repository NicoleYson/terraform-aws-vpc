resource "aws_subnet" "private" {
  count             = local.az_count
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block = cidrsubnet(
    var.cidr_block,
    var.cidr_block_newbits,
    length(aws_subnet.public) + count.index + local.subnet_buffer,
  )
  map_public_ip_on_launch = false

  tags = merge(
    var.private_subnet_tags,
    local.universal_tags,
    {
      "Name"       = "private-${lower(substr(element(data.aws_availability_zones.available.names, count.index), -1, -1))}"
      "Visibility" = "private"
    },
  )
}

resource "aws_subnet" "public" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = cidrsubnet(var.cidr_block, var.cidr_block_newbits, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.public_subnet_tags,
    local.universal_tags,
    {
      "Name"       = "public-${lower(substr(element(data.aws_availability_zones.available.names, count.index), -1, -1))}"
      "Visibility" = "public"
    },
  )
}

locals {
  az_count      = min(length(data.aws_availability_zones.available.names), 4)
  subnet_buffer = local.az_count < 4 ? 4 - local.az_count : 0
}
