variable "accounts_db_user" {
  type        = string
  description = "The name of the new accounts database user"
  default     = "accounts_admin"
}

variable "accounts_db_name" {
  type        = string
  description = "The name of the new accounts database"
  default     = "accounts_db"
}
