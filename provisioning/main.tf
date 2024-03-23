resource "aws_instance" "web" {
  ami                         = "ami-080e1f13689e07408"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ansible"
  vpc_security_group_ids      = ["sg-01812b8bb24c1d56e"]
  availability_zone           = "us-east-1a"

  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/Downloads/ansible.pem")
  }
  provisioner "file" {
    source      = "./installapache.sh"
    destination = "/tmp/installapache.sh"
  }
  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/installapache.sh",
    "/tmp/installapache.sh", ]

  }
}