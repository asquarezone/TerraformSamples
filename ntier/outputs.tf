output "publicip" {
  value = aws_instance.web_1.public_ip
}

output "vpc_id" {
  value = aws_vpc.network.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}