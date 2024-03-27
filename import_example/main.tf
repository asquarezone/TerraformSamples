resource "aws_security_group" "ubuntu" {
  description = "launch-wizard-1 created 2024-03-27T05:25:11.221Z"
  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    description     = ""
    from_port       = 0
    protocol        = "-1"
    security_groups = []
    to_port         = 0
  }
  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    description     = ""
    from_port       = 22
    protocol        = "tcp"
    security_groups = []
    to_port         = 22
  }
  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    description     = ""
    from_port       = 443
    protocol        = "tcp"
    security_groups = []
    to_port         = 443
  }
  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    description     = ""
    from_port       = 80
    protocol        = "tcp"
    security_groups = []
    to_port         = 80
  }
  name   = "openhttpsnhttp"
  vpc_id = "vpc-03f22673504092d57"
}


resource "aws_instance" "ubuntu_server" {
  ami                         = "ami-0fe630eb857a6ec83"
  associate_public_ip_address = true
  availability_zone           = "us-east-1b"
  instance_type               = "t2.micro"
  key_name                    = "ansible"
  monitoring                  = false
  tags = {
    Name = "Test Server"
  }
  tags_all = {
    Name = "Test Server"
  }
  vpc_security_group_ids = ["sg-06929847d760738a0"]
}
