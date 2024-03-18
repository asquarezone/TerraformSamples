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
    cidr_block = "0.0.0.0/0"
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

# todo: replace this ugly block
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnets[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.subnets[1].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.subnets[2].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.subnets[3].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.subnets[4].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private4" {
  subnet_id      = aws_subnet.subnets[5].id
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and ssh inbound traffic"
  vpc_id      = aws_vpc.network.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



