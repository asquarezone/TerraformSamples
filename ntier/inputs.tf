variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_names" {
  type    = list(string)
  default = ["web-1", "web-2", "app-1", "app-2", "db-1", "db-2"]
}

variable "availability_zone_values" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]

}