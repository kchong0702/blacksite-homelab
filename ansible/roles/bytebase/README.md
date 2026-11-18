# bytebase

Runs Bytebase and its metadata Postgres with compose. Bytebase listens on `127.0.0.1:8080`, and the metadata Postgres runs in the `bytebase-postgres` container that `pg_backup` dumps.

Needs the `docker` role first. Put Caddy in front of it to reach it over the tailnet.

It replaces `compose.yaml` and `.env` in `bytebase_dir`.

## Variables

Run `ansible-doc -t role -r roles bytebase` from `ansible/` for the full list, read from `meta/argument_specs.yml`. `bytebase_external_url` is required, and `BYTEBASE_POSTGRES_PASSWORD` must be set.

## Example

```yaml
- hosts: bytebase_servers
  become: true
  roles:
    - role: bytebase
      vars:
        bytebase_external_url: https://bytebase.example.com
```

## Behaviour

Idempotent: yes. Changing `BYTEBASE_POSTGRES_PASSWORD` after the first run does not change the password inside the existing Postgres volume.
