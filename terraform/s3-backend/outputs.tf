
output "backend_s3_bucket_name" {
  value = resource.aws_s3_bucket.terraform_state.bucket
}

output "backend_dynamodb_table_name" {
  value = resource.aws_dynamodb_table.terraform_locks.name
}
