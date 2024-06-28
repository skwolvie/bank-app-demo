# Local values for RDS endpoint without port and master database credentials
locals {
  rds_endpoint_without_port = element(split(":", data.terraform_remote_state.infrastructure.outputs.rds_endpoint), 0)
  master_db_credentials     = jsondecode(data.aws_secretsmanager_secret_version.master_db_password.secret_string)
}
