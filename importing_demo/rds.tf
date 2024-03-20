resource "aws_security_group" "mssql" {
  description = "Created by RDS management console"
  egress {
    cidr_blocks = [
      local.anywhere_ipv4,
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  ingress {
    cidr_blocks = [
      "183.82.111.145/32",
    ]
    from_port = 1433
    protocol  = "tcp"
    to_port   = 1433
  }
  name   = "mssql"
  vpc_id = aws_vpc.network.id
}

# db subnet group
resource "aws_db_subnet_group" "mssql" {
  description = "this is db subnet group"
  name        = "db"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
}

# rds instance
resource "aws_db_instance" "mssql" {
  allocated_storage          = 20
  auto_minor_version_upgrade = false
  backup_retention_period    = 1
  copy_tags_to_snapshot      = true
  db_subnet_group_name       = aws_db_subnet_group.mssql.name
  delete_automated_backups   = true
  engine                     = "sqlserver-ex"
  engine_version             = "15.00.4355.3.v1"
  identifier                 = "dmtdemodb"
  instance_class             = "db.t3.micro"
  license_model              = "license-included"
  maintenance_window         = "thu:09:02-thu:09:32"
  max_allocated_storage      = 1000
  monitoring_interval        = 0
  multi_az                   = false
  publicly_accessible        = false
  storage_type               = "gp2"
  username                   = "admin"
  skip_final_snapshot        = true
  vpc_security_group_ids = [
    aws_security_group.mssql.id,
  ]
}