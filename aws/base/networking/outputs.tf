################################################
################ Outputs
################################################

# VPC
output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

# Public Subnets
output "main_public_subnet_ids" {
  value = aws_subnet.main_public_subnets.*.id
}

# Private Subnets
output "main_private_subnet_ids" {
  value = aws_subnet.main_private_subnets.*.id
}