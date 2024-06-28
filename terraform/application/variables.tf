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

variable "ledger_db_user" {
  type        = string
  description = "The name of the new ledger database user"
  default     = "ledger_admin"
}

variable "ledger_db_name" {
  type        = string
  description = "The name of the new ledger database"
  default     = "ledger_db"
}
