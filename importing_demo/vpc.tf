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

# private subnet 2
resource "aws_subnet" "private_2" {
  availability_zone = var.private_subnet_2.availability_zone
  cidr_block        = var.private_subnet_2.cidr_block
  tags = {
    "Name" = var.private_subnet_2.name
  }
  vpc_id = aws_vpc.network.id
}



#public subnet 1
resource "aws_subnet" "public_1" {
  availability_zone = var.public_subnet_1.availability_zone
  cidr_block        = var.public_subnet_1.cidr_block
  tags = {
    "Name" = var.public_subnet_1.name
  }
  vpc_id = aws_vpc.network.id
}

# public subnet 2
resource "aws_subnet" "public_2" {
  availability_zone = var.public_subnet_2.availability_zone
  cidr_block        = var.public_subnet_2.cidr_block
  tags = {
    "Name" = var.public_subnet_2.name
  }
  vpc_id = aws_vpc.network.id
}

# private route table 1
resource "aws_route_table" "private_1" {
  route {
    cidr_block     = local.anywhere_ipv4
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "mock-rtb-private1-us-east-1a"
  }
  vpc_id = aws_vpc.network.id
}


# private route table 2
resource "aws_route_table" "private_2" {
  route {
    cidr_block     = local.anywhere_ipv4
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "mock-rtb-private2-us-east-1b"
  }
  vpc_id = aws_vpc.network.id
}

resource "aws_route_table" "public" {
  route {
    cidr_block = local.anywhere_ipv4
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "mock-rtb-public"
  }
  vpc_id = aws_vpc.network.id
}

# import internet gateway
resource "aws_internet_gateway" "igw" {
  tags = {
    "Name" = "mock-igw"
  }
  vpc_id = aws_vpc.network.id
}

# aws_route_table_association.private_1:
resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_2.id
  subnet_id      = aws_subnet.private_2.id
}

resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1.id
}

resource "aws_route_table_association" "public_2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_2.id
}

# nat
resource "aws_nat_gateway" "nat" {
  allocation_id     = aws_eip.natip.allocation_id
  subnet_id         = aws_subnet.public_1.id
  connectivity_type = "public"
  tags = {
    "Name" = "mock-nat-public1-us-east-1a"
  }
}

# elastic ip

resource "aws_eip" "natip" {
  domain = "vpc"
  tags = {
    "Name" = "mock-eip-us-east-1a"
  }
}

resource "aws_eip_association" "natip" {
  allocation_id        = aws_eip.natip.id
  network_interface_id = aws_nat_gateway.nat.network_interface_id
}

resource "aws_vpc_endpoint" "s3endpoint" {
  route_table_ids = [
    aws_route_table.private_1.id,
    aws_route_table.private_2.id,
  ]
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    "Name" = "mock-vpce-s3"
  }
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.network.id
}
