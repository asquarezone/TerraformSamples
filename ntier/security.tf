resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and ssh inbound traffic"
  vpc_id      = aws_vpc.network.id

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp
    cidr_blocks = [local.any_where]
  }
  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = local.tcp
    cidr_blocks = [local.any_where]
  }
  egress {
    from_port        = local.any_port
    to_port          = local.any_port
    protocol         = local.any_protocol
    cidr_blocks      = [local.any_where]
    ipv6_cidr_blocks = [local.any_where_ipv6]
  }
}