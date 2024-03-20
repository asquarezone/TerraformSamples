# imported vpc
resource "aws_vpc" "network" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  enable_dns_support   = var.vpc.enable_dns_support
  tags = {
    "Name" = var.vpc.name
  }
}

# imported subnets

#private subnet 1
resource "aws_subnet" "private_1" {
  availability_zone = var.private_subnet_1.availability_zone
  cidr_block        = var.private_subnet_1.cidr_block
  tags = {
    "Name" = var.private_subnet_1.name
  }
  vpc_id = aws_vpc.network.id
}