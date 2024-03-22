variable "vpc_id" {
  type        = string
  description = "this is vpc_id in which security group has to be created"
}

variable "name" {
  type        = string
  description = "this is name of security group"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "openssh"
    }
  ]

}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "all traffic"
    }
  ]

}
