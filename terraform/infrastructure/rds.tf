# Security Group module for the database
module "database-security-group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=43974e94067251ee464018288aa44862d0adba22"

  # Basic configuration of the security group
  name        = "bank-app-demo-database-sg"
  description = "Bank app demo project database security group"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules for the security group, allowing database access from within the VPC
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Database access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}

# RDS module for creating the database instance
module "rds" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds.git?ref=7bb82a6e7646837cbacac2badcb618329fa25963"

  # Database configuration using variables
  identifier = "bank-app-demo-db"

  engine               = "postgres"
  engine_version       = "15"
  family               = "postgres15"
  major_engine_version = "15"
  instance_class       = "db.t3.micro"

  allocated_storage     = 10
  max_allocated_storage = 50

  db_name  = "bank_app_db"
  username = var.database_user
  port     = 5432

  # High availability and network configuration
  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.database-security-group.security_group_id]

  backup_retention_period = 0
}
