output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_route_table_id" {
  value = aws_route_table.public.*.id
}

output "private_route_table_id" {
  value = aws_route_table.private.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private.*.cidr_block
}

output "public_subnet_cidrs" {
  value = aws_subnet.public.*.cidr_block
}

output "universal_tags" {
  value = local.universal_tags
}

output "default_sg_id" {
  value = aws_default_security_group.default.id
}
