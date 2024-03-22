data "aws_vpc" "network" {
  default = true

}


module "secuirty_group" {
  source = "./modules/security_group"
  vpc_id = data.aws_vpc.network.id
  name   = "openhttpnssh"
  ingress_rules = [{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "open ssh"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "open http"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "open https"
    }

  ]
  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "open all"
  }]

}