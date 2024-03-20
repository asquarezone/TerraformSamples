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

variable "private_subnet_2" {
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })

  default = {
    cidr_block        = "10.0.144.0/20"
    availability_zone = "us-east-1b"
    name              = "mock-subnet-private2-us-east-1b"
  }

}


variable "public_subnet_1" {
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })

  default = {
    cidr_block        = "10.0.0.0/20"
    availability_zone = "us-east-1a"
    name              = "mock-subnet-public1-us-east-1a"
  }

}

variable "public_subnet_2" {
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })

  default = {
    cidr_block        = "10.0.16.0/20"
    availability_zone = "us-east-1b"
    name              = "mock-subnet-public2-us-east-1b"
  }

}


variable "ami" {
  type    = string
  default = "ami-03cd80cfebcbb4481"
}

variable "key_pair_name" {
  type    = string
  default = "ansible"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}