# vpc
resource "aws_vpc" "network" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "ntier-vpc"
    Environment = "dev"
    CreatedBy   = "terraform"
  }
}

# subnet
resource "aws_subnet" "subnets" {
  count      = length(var.subnet_names)
  vpc_id     = aws_vpc.network.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  tags = {
    Name        = var.subnet_names[count.index]
    Environment = "dev"
    CreatedBy   = "terraform"
  }
  availability_zone = var.availability_zone_values[count.index]
  depends_on        = [aws_vpc.network]
}

# create and attach internet gateway
resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name        = "ntier-igw"
    Environment = "dev"
    CreatedBy   = "terraform"
  }
  depends_on = [aws_vpc.network]
}

# create a public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id
  route {
    cidr_block = local.any_where
    gateway_id = aws_internet_gateway.ntier_igw.id
  }
  tags = {
    Name        = "ntier-public-rt"
    Environment = "dev"
    CreatedBy   = "terraform"
  }
  depends_on = [aws_vpc.network, aws_subnet.subnets]
}

# private route table
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.network.id
  depends_on = [aws_vpc.network, aws_subnet.subnets]
  tags = {
    Name        = "ntier-private-rt"
    Environment = "dev"
    CreatedBy   = "terraform"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.network.id]
  }
  depends_on = [aws_subnet.subnets]
}

resource "aws_route_table_association" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  subnet_id      = each.key
  route_table_id = aws_route_table.public.id
  depends_on = [ data.aws_subnets.public ]
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = var.private_subnet_names
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.network.id]
  }
  depends_on = [aws_subnet.subnets]
}

resource "aws_route_table_association" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  subnet_id      = each.key
  route_table_id = aws_route_table.private.id
  depends_on = [ data.aws_subnets.private ]
}



