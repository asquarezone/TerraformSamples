resource "aws_vpc" "network" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "ntier-vpc"
    Environment = "dev"
    CreatedBy   = "terraform"
  }
}

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