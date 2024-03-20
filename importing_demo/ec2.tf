resource "aws_security_group" "windows" {
  description = "launch-wizard-2 created 2024-03-20T06:33:13.921Z"
  egress {
    cidr_blocks = [
      local.anywhere_ipv4,
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  ingress {
    cidr_blocks = [
      local.anywhere_ipv4,
    ]
    from_port = 3389
    protocol  = "tcp"
    to_port   = 3389
  }
  name   = "windows"
  vpc_id = aws_vpc.network.id
}


resource "aws_instance" "win_public_1" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.public_2.id
  tags = {
    "Name" = "windows"
  }
  vpc_security_group_ids = [
    aws_security_group.windows.id,
  ]
}