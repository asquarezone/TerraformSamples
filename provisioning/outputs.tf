output "url" {
  value = format("http://%s", aws_instance.web.public_ip)
}