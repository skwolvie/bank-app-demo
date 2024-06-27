output "rds_name" {
  description = "The name of the RDS instance"
  value       = module.rds.db_instance_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "The port on which the RDS instance is listening"
  value       = module.rds.db_instance_port
  sensitive   = true
}

output "lambda_function_name" {
  value = aws_lambda_function.create_database.function_name
}

output "db_secret_arn" {
  description = "The arn of the database credentials secret"
  value       = module.rds.db_instance_master_user_secret_arn
  sensitive   = true
}

