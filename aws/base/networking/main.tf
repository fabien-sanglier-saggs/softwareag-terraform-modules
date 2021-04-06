# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-internet-gateway"
  }
}

# NAT Gateway Elastic IP
resource "aws_eip" "main_nat_gateway_elastic_ip" {
  count = length(var.private_subnets_cidr)
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "main_nat_gateway" {
  count         = length(var.public_subnets_cidr)
  allocation_id = element(aws_eip.main_nat_gateway_elastic_ip.*.id,count.index)
  subnet_id     = element(aws_subnet.main_public_subnets.*.id,count.index)

  depends_on = [aws_internet_gateway.main_internet_gateway]

  tags = {
    Name = "main-nat-gateway"
  }
}

# Public Subnets
resource "aws_subnet" "main_public_subnets" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.public_subnets_cidr,count.index)
  availability_zone = element(var.availability_zones,count.index)

  tags = {
    Name = "main_public_subnet_${count.index+1}"
  }
}

# Private Subnets
resource "aws_subnet" "main_private_subnets" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnets_cidr,count.index)
  availability_zone = element(var.availability_zones,count.index)

  tags = {
    Name = "main-control-plane-private-subnet_${count.index+1}"
  }
}

# Public Route table: attach Internet Gateway
resource "aws_route_table" "main_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }

  tags = {
    Name = "main-control-plane-public-route-table"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "main_public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.main_public_subnets.*.id,count.index)
  route_table_id = aws_route_table.main_public_route_table.id
}

# Private Route table: attach NAT Gateway
resource "aws_route_table" "main_private_route_table" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gateway[count.index].id
  }

  tags = {
    Name = "main_private_route_table_${count.index+1}"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "main_private_route_table_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.main_private_subnets.*.id,count.index)
  route_table_id = aws_route_table.main_private_route_table[count.index].id
}