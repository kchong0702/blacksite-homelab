# base

Installs the base packages, including `unattended-upgrades` and `ufw`. It then sets ufw to deny all inbound traffic except on `tailscale0`, and enables it.

Run it after `tailscale`, or the host loses the connection Ansible uses.

## Variables

Run `ansible-doc -t role -r roles base` from `ansible/` for the full list, read from `meta/argument_specs.yml`.

## Example

```yaml
- hosts: all
  become: true
  roles:
    - tailscale
    - base
```

## Behaviour

Idempotent: yes. The ufw commands report no change because ufw skips rules it already has.
