resource "aws_instance" "web_1" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnets[0].id
  security_groups             = [aws_security_group.web_sg.id]
  key_name                    = var.key_pair_name
  instance_type               = "t2.micro"
  tags = {
    Name        = "web_1"
    Environment = "dev"
    CreatedBy   = "Terraform"
  }
}