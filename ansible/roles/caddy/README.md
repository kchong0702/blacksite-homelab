# caddy

Builds a Caddy image with the Cloudflare DNS plugin and runs it with compose on the host network. Each site in `caddy_sites` binds to the host's `tailscale0` address and gets a certificate through a DNS-01 challenge, so no port is open to the internet.

Needs the `tailscale` and `docker` roles first.

It replaces these files in `caddy_dir`: `Dockerfile`, `Caddyfile`, `compose.yaml` and `.env`.

## Variables

Run `ansible-doc -t role -r roles caddy` from `ansible/` for the full list, read from `meta/argument_specs.yml`. `CLOUDFLARE_DNS_API_TOKEN` must be set.

## Example

```yaml
- hosts: app_servers
  become: true
  roles:
    - role: caddy
      vars:
        caddy_sites:
          - host: app.example.com
            upstream: 127.0.0.1:8080
```

## Behaviour

Idempotent: yes. A change to the Caddyfile or the token restarts Caddy. Template changes keep a timestamped backup next to the file.
