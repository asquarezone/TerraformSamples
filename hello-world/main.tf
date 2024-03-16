resource "aws_vpc" "ntier" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "ntier"
    Environment = "dev"
  }
}

resource "aws_subnet" "web" {
  # implicit dependency on the VPC
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name        = "web"
    Environment = "dev"
  }
  # explicit dependency on the VPC
  depends_on = [aws_vpc.ntier]
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name        = "app"
    Environment = "dev"
  }
  depends_on = [aws_vpc.ntier]

}