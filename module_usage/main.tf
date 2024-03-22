module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.6.0"
  name                 = "ntier-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id
  egress_rules        = ["all-all"]
  ingress_cidr_blocks      = ["10.0.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "db"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "ansible"
  monitoring             = true
  associate_public_ip_address = true
  vpc_security_group_ids = [module.web_server_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "dmtdemodb"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t2.micro"
  allocated_storage = 20

  db_name  = "demodb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.db_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # Database Deletion Protection
  deletion_protection = false
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"  
}

#  break for 5 mins