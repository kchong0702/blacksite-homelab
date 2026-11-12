# Add a database to Bytebase

1. In Supabase, open Connect and copy the session pooler details. The host is `aws-0-<region>.pooler.supabase.com`, the port is `5432` and the user is `postgres.<project-ref>`.
2. Export `TF_VAR_ops_api_db_username` and `TF_VAR_ops_api_db_password` for that user.
3. For a new instance, add a `bytebase_instance` to `terraform/environments/prod/bytebase/main.tf` with `use_ssl = true`, and add a matching variable for its connection in `variables.tf` and `terraform.tfvars`. Keep username and password as sensitive variables set through `TF_VAR_*`.
4. Apply `terraform/environments/prod/bytebase`.
5. To back the database up, add it to `pg_backup_databases` in `ansible/inventories/prod/group_vars/all.yml` with a `url_env` name, export that variable with the full connection URL and run the playbook.
