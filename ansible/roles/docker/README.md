# docker

Installs Docker and the compose plugin from Ubuntu's archive (`docker.io`, `docker-compose-v2`) and starts the Docker service.

## Variables

Run `ansible-doc -t role -r roles docker` from `ansible/` for the full list, read from `meta/argument_specs.yml`.

## Example

```yaml
- hosts: all
  become: true
  roles:
    - docker
```

## Behaviour

Idempotent: yes.
