# Add a database to Bytebase

1. In Supabase, open Connect and copy the session pooler details. The host is `aws-0-<region>.pooler.supabase.com`, the port is `5432` and the user is `postgres.<project-ref>`.
2. Save that user and its password as secrets. For ops-api they are `OPS_API_DB_USERNAME` and `OPS_API_DB_PASSWORD`, which Deploy passes to `prod/bytebase` as `TF_VAR_ops_api_db_username` and `TF_VAR_ops_api_db_password`.
3. Open a pull request with the connection details.
   - For ops-api, create `terraform/environments/prod/bytebase/terraform.tfvars` with `ops_api_db = { host = "<pooler host>" }`. The port, database and SSL settings have defaults.
   - For another database, add a `bytebase_instance` to `terraform/environments/prod/bytebase/main.tf` with `use_ssl = true` and a matching connection variable in `variables.tf` and `terraform.tfvars`. Add its username and password as sensitive variables, save them as new secrets, and map them to `TF_VAR_*` in the `databases` job of `.github/workflows/deploy.yml`.
   - To back the database up, add it to `pg_backup_databases` in `ansible/group_vars/backup_servers/pg_backup.yml` with a `url_env` name. Save the full connection URL as a secret of that name and map it in the `configuration` job's "Run the playbook" step of `.github/workflows/deploy.yml`.
4. Check the `databases` plan in the pull request and merge it. Deploy registers the instance in Bytebase and installs the new backup settings.
