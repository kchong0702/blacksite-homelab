# tailscale

Installs Tailscale from its install script, joins the tailnet if the host is not on it yet, and turns on Tailscale SSH. It keeps the host's own DNS (`--accept-dns=false`).

Run it first: the `base` role closes every inbound port except `tailscale0`.

## Variables

Run `ansible-doc -t role -r roles tailscale` from `ansible/` for the full list, read from `meta/argument_specs.yml`. `TAILSCALE_AUTH_KEY` must be set only when the host is not on the tailnet yet.

## Example

```yaml
- hosts: all
  become: true
  roles:
    - tailscale
```

## Behaviour

Idempotent: yes. A host that is already `Running` is not re-joined, so later runs need no auth key.
