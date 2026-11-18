# pg_backup

Installs a backup script and a daily systemd timer. The script dumps each database in `pg_backup_databases` and syncs the dumps to an R2 bucket under a UTC timestamp prefix.

Each entry in `pg_backup_databases` sets one of these:

- `container` and `user`: the role dumps a Postgres container on this host with `docker exec`.
- `url_env`: the role reads the named environment variable on the controller, writes it to the root-only env file, and dumps that database with a throwaway `postgres` container.

Needs the `docker` role first.

It replaces `pg_backup_env_file`, `pg_backup_script`, and `pg-backup.service` and `pg-backup.timer` in `/etc/systemd/system`.

## Variables

Run `ansible-doc -t role -r roles pg_backup` from `ansible/` for the full list, read from `meta/argument_specs.yml`. `pg_backup_bucket` is required. `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY` and each `url_env` variable must be set.

## Example

```yaml
- hosts: backup_servers
  become: true
  roles:
    - role: pg_backup
      vars:
        pg_backup_bucket: backups
        pg_backup_databases:
          - name: app
            container: app-postgres
            user: app
          - name: ops
            url_env: OPS_DATABASE_URL
```

## Behaviour

Idempotent: yes. Run `systemctl start pg-backup` on the host to take a backup now. The env file holds secrets, so it keeps no backup copy.
