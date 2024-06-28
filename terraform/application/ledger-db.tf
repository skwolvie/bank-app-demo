# Generating a random string for the aws secret name
resource "random_string" "ledger_db_secret" {
  length  = 6
  upper   = true
  lower   = true
  numeric = true
  special = false
}

# Creating a new secret in AWS Secrets Manager to store the database credentials 
resource "aws_secretsmanager_secret" "ledger_db_secret" {
  name        = "ledger-db-secret-${random_string.ledger_db_secret.result}"
  description = "The name of the aws secret confining the database credentials for the ledger database"
}

# Generating a random password for the new database user
resource "random_password" "ledger_db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Creating a new secret version in AWS Secrets Manager with the ledger database credentials
resource "aws_secretsmanager_secret_version" "ledger_database_credentials" {
  secret_id = aws_secretsmanager_secret.ledger_db_secret.id
  secret_string = jsonencode({
    username = var.ledger_db_user
    password = random_password.ledger_db_password.result
    dbname   = var.ledger_db_name
  })
}

# Triggering the Lambda function to create a new database user and database (TEMPORARY, WILL BE REPLACED IN THE PIPELINE)
resource "null_resource" "create_ledger_db" {
  provisioner "local-exec" {
    command = <<EOT
    aws lambda invoke \
    --function-name "${data.terraform_remote_state.infrastructure.outputs.lambda_function_name}" \
    --payload '${base64encode(templatefile("${path.module}/payload.json.tpl", {
    dbname          = data.terraform_remote_state.infrastructure.outputs.rds_name,
    dbuser          = local.master_db_credentials["username"],
    dbpassword      = local.master_db_credentials["password"],
    dbhost          = local.rds_endpoint_without_port,
    newuser         = var.ledger_db_user,
    newuserpassword = random_password.ledger_db_password.result,
    newdb           = var.ledger_db_name
}))}' response.json
    EOT
}
}

# Creating a Kubernetes secret to store the ledger database credentials
resource "kubernetes_secret" "ledger_db_credentials" {
  # Metadata for the Kubernetes secret
  metadata {
    name = "ledger-db-credentials"
    labels = {
      app         = "ledger-db"
      application = "bank-of-anthos"
      environment = "development"
      team        = "ledger"
      tier        = "db"
    }
  }
  # Encoding the database credentials in base64
  data = {
    username      = var.ledger_db_user
    password      = random_password.ledger_db_password.result
    db_name       = var.ledger_db_name
    db_endpoint   = local.rds_endpoint_without_port
    ledger_db_uri = "postgresql://${var.ledger_db_user}:${random_password.ledger_db_password.result}@${local.rds_endpoint_without_port}/${var.ledger_db_name}"
  }
}
