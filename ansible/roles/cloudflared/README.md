# cloudflared

Runs the Cloudflare Tunnel connector with compose on the host network. Terraform owns the tunnel and its routes, and this role only runs the connector with the tunnel token.

Needs the `docker` role first.

It replaces `compose.yaml` and `.env` in `cloudflared_dir`.

## Variables

Run `ansible-doc -t role -r roles cloudflared` from `ansible/` for the full list, read from `meta/argument_specs.yml`. `CLOUDFLARE_TUNNEL_TOKEN` must be set.

## Example

```yaml
- hosts: app_servers
  become: true
  roles:
    - cloudflared
```

## Behaviour

Idempotent: yes. A change to the token restarts the connector.
