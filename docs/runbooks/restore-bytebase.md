# Restore Bytebase from a backup

1. On the host, stop Bytebase: `docker compose -f /opt/bytebase/compose.yaml stop bytebase`.
2. Download the newest dump from the `backups` bucket. Dumps sit under `<timestamp>/bytebase-<timestamp>.sql.gz`. The host has no AWS CLI, so use the same container the backup uses: `set -a; . /etc/pg-backup.env; set +a; docker run --rm -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=auto -v "$PWD":/out amazon/aws-cli:2.40.1 s3 cp s3://backups/<timestamp>/bytebase-<timestamp>.sql.gz /out/ --endpoint-url "https://$R2_ACCOUNT_ID.r2.cloudflarestorage.com"`.
3. Reset the database: `docker exec bytebase-postgres psql -U bytebase -d postgres -c 'DROP DATABASE bytebase' -c 'CREATE DATABASE bytebase OWNER bytebase'`.
4. Load the dump: `gunzip -c bytebase-<timestamp>.sql.gz | docker exec -i bytebase-postgres psql -U bytebase -d bytebase`.
5. Start Bytebase: `docker compose -f /opt/bytebase/compose.yaml start bytebase`.
