resource "aws_iam_role" "fors3" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "ec2.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "Allows EC2 instances to call AWS services on your behalf."
    force_detach_policies = false
    name                  = "fors3automation"
    path                  = "/"
}


resource "aws_instance" "ubuntu" {
    ami                                  = "ami-0fe630eb857a6ec83"
    associate_public_ip_address          = true
    availability_zone                    = "us-east-1b"
    iam_instance_profile                 = aws_iam_role.fors3.name
    instance_type                        = "t2.micro"
    key_name                             = "ansible"
    tags                                 = {
        "Name" = "Test Server"
    }
    vpc_security_group_ids               = [
        "sg-06929847d760738a0",
    ]

}