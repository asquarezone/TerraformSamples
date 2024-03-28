variable "ami" {
    type        = string
    description = "AMI to use for the instance"
    default     = "ami-0aba5af2d290ca42f"
}


variable "security_group_id" {
    type = string
    description = "Security group id"
    default = "sg-01812b8bb24c1d56e"
}

variable "key_name" {
    type = string
    description = "Key name"
    default = "ansible"
}
