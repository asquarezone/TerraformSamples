resource "aws_instance" "ubuntu" {
    ami = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    key_name = "ansible"
    associate_public_ip_address = true
    vpc_security_group_ids = ["sg-01812b8bb24c1d56e"]
    subnet_id = "subnet-068da44055b5121fd"
    user_data = file("installapache.sh")
  
}