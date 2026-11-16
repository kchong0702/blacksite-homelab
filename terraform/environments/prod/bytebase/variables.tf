variable "ops_api_db" {
  description = "Connection details of the ops-api database, the Supabase session pooler."
  type = object({
    host     = string
    port     = optional(string, "5432")
    database = optional(string, "postgres")
    use_ssl  = optional(bool, true)
  })
}

variable "ops_api_db_username" {
  description = "Database user Bytebase connects as."
  type        = string
  sensitive   = true
}

variable "ops_api_db_password" {
  description = "Password of ops_api_db_username."
  type        = string
  sensitive   = true
}
