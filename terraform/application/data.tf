data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket  = "banking-demo-terraform-states"
    key     = "infrastructure-state/terraform.tfstate"
    region  = "us-west-1"
    profile = "personal"
  }
}

# Retrieving the RDS database password from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "master_db_password" {
  secret_id = data.terraform_remote_state.infrastructure.outputs.db_secret_arn
}

