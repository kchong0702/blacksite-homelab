# app_host

Creates the user the renderverse CI deploys as and adds it to the `docker` group. It also creates the directory, owned by that user, that holds the app's compose project. This repo never runs the app containers.

Needs the `docker` role first, for the `docker` group.

## Variables

Run `ansible-doc -t role -r roles app_host` from `ansible/` for the full list, read from `meta/argument_specs.yml`.

## Example

```yaml
- hosts: app_servers
  become: true
  roles:
    - app_host
```

## Behaviour

Idempotent: yes.
