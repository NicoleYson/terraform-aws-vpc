# Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.universal_tags,
    {
      "Name"       = "public"
      "Visibility" = "public"
    },
  )
}

resource "aws_route" "public_route" {
  count = local.az_count

  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
  count          = local.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Private
resource "aws_route_table" "private" {
  count  = local.az_count
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.universal_tags,
    {
      "Name"       = "private-${lower(substr(element(data.aws_availability_zones.available.names, count.index), -1, -1))}"
      "Visibility" = "private"
    },
  )
}

resource "aws_route_table_association" "private" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "private_nat_gateway" {
  count                  = local.az_count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
}

# Gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.universal_tags,
    {
      "Name" = "${var.scope} IGW"
    },
  )
}

resource "aws_eip" "nat" {
  count          = local.az_count
  vpc            = true
}

resource "aws_nat_gateway" "nat" {
  count          = local.az_count
  depends_on     = [aws_internet_gateway.igw]

  allocation_id  = element(aws_eip.nat.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)

  tags = merge(
    local.universal_tags,
    {
      "Name" = "${var.scope} NAT GW"
    },
  )
}
