

resource "aws_instance" "EC2Instance" {
  ami               = "ami-07ee27150f463b714"
  instance_type     = "t2.micro"
  key_name          = "exported"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [
    "sg-09d82734f0ee8a0c6"
  ]
  tags = {
    Name = "nopcommerce"
  }
}

resource "aws_db_instance" "nop" {
    allocated_storage                     = 20
    auto_minor_version_upgrade            = true
    availability_zone                     = "us-east-1d"
    backup_retention_period               = 0
    delete_automated_backups              = true
    deletion_protection                   = false
    engine                                = "mysql"
    engine_version                        = "8.0.35"
    identifier                            = "dmt-nopdb"
    instance_class                        = "db.t3.micro"
    max_allocated_storage                 = 1000
    monitoring_interval                   = 0
    multi_az                              = false
    name                                  = "employees"
    port                                  = 3306
    publicly_accessible                   = true
    skip_final_snapshot                   = true
    username                              = "admin"
    vpc_security_group_ids                = [
        "sg-018e3a533d4f65c6e",
    ]

    timeouts {}
}