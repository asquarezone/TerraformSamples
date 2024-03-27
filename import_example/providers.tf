terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

import {
  id = "i-0ede93b18567eb0d5"
  to = aws_instance.ubuntu_server

}

import {
  id = "sg-06929847d760738a0"
  to = aws_security_group.ubuntu

}