provider "bytebase" {}

resource "bytebase_instance" "ops_api" {
  resource_id = "ops-api"
  title       = "ops-api"
  engine      = "POSTGRES"
  environment = "environments/prod"

  data_sources {
    id       = "admin"
    type     = "ADMIN"
    host     = var.ops_api_db.host
    port     = var.ops_api_db.port
    database = var.ops_api_db.database
    username = var.ops_api_db_username
    password = var.ops_api_db_password
    use_ssl  = var.ops_api_db.use_ssl
  }
}
