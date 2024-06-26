variable "iam_policy_document_principal_arns" {
  description = "The principal arns as list of strings to grant access to the kms key"
  type        = list(string)
  default     = []
}

variable "kms_key_deletion_period" {
  description = "The deletion window in days for the kms key"
  type        = number
  default     = 7
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "The name of the dynamodb table"
  type        = string
  default     = ""
}
