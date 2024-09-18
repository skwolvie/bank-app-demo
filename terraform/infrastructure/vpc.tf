# VPC module for creating the Virtual Private Cloud on AWS
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=e4768508a17f79337f9f1e48ebf47ee885b98c1f"

  # Setting up VPC parameters using variables
  name = "wordpress-project-vpc"
  cidr = "10.0.0.0/16"

  # Define availability zones and subnet types for the VPC
  azs              = ["us-west-1a", "us-west-1b"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]
  intra_subnets    = ["10.0.31.0/24", "10.0.32.0/24"]


  # Enable a database subnet group and NAT gateway for outbound traffic
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  # Tagging subnets for identification and management
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Terraform   = "true"
    Environment = "demo"
    Project     = "bank-app-demo"
  }
}
