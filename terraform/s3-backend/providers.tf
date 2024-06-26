# Terraform block specifying the required providers and their versions
terraform {
  required_version = "1.6.6"

  backend "s3" {
    bucket         = "banking-demo-terraform-state"
    key            = "backend-state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "banking-demo-terraform-state-lock"
    encrypt        = true
    profile        = "personal"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.0"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region  = "eu-central-1"
  profile = "personal"
}
