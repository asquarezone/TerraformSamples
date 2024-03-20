variable "vpc" {
  type = object({
    cidr_block           = string
    name                 = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
  })

  default = {
    cidr_block           = "10.0.0.0/16"
    name                 = "mock-vpc"
    enable_dns_hostnames = true
    enable_dns_support   = true
  }

}

variable "private_subnet_1" {
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })

  default = {
    cidr_block        = "10.0.128.0/20"
    availability_zone = "us-east-1a"
    name              = "mock-subnet-private1-us-east-1a"
  }

}