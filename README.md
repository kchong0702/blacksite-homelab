# blacksite-homelab

Infrastructure for one tailnet VM that hosts Bytebase and the renderverse backend services, plus the Cloudflare side of kelvinchong.dev. The VM can sit on AWS, GCP or Contabo and moves between them as credits run out.

## The picture

- The renderverse SPA runs on Cloudflare Pages at `kelvinchong.dev` and `www.kelvinchong.dev`.
- ezbot is public through a Cloudflare tunnel at `ezbot.kelvinchong.dev`. cloudflared runs on the host network and reaches ezbot's published port `127.0.0.1:8000`.
- ops-web at `ops.kelvinchong.dev` and Bytebase at `bytebase.kelvinchong.dev` are tailnet only. The DNS records are grey-cloud A records that hold the VM's tailnet IP. Caddy on the VM serves them on the tailscale0 address with DNS-01 certificates.
- App databases live on Supabase free. Bytebase keeps its own metadata in Postgres on the VM.
- R2 holds the `portfolio` bucket (public at `assets.kelvinchong.dev`), `uploads`, and the private `backups` bucket that receives the daily Postgres dumps.
- The VM has no inbound public ports. Tailscale SSH is the only way in.

## Who owns what

| Tool | Owns |
| --- | --- |
| Terraform | Anything behind an API: the VM, the cloud network, Tailscale policy and DNS, Cloudflare Pages, R2, tunnel, DNS and zone settings, Bytebase instances |
| Ansible | Anything on the VM's disk: packages, firewall, Tailscale join, Docker, Caddy, cloudflared, Bytebase, the backup timer |
| renderverse CI | The app containers in `/srv/renderverse`. This repo never runs the app compose |

## Layout

```
terraform/modules/        one module per resource group, no provider config
terraform/environments/   one stack per HCP workspace: global/{tailscale,cloudflare}, prod/{aws,gcp,contabo,cloudflare,bytebase}
ansible/                  inventories, playbooks/site.yml and one role per concern
docs/runbooks/            bootstrap, move-host, add-database, restore-bytebase
```

Only one of `prod/aws`, `prod/gcp` and `prod/contabo` holds a host at a time. Each takes `hosts = { <name> = { size = "small" | "medium" } }`.

## Setup

```
mise install
pre-commit install
```

Each Terraform stack runs in an HCP Terraform workspace named `<scope>-<stack>` in Local execution mode. Set `TF_CLOUD_ORGANIZATION` and `TF_TOKEN_app_terraform_io` before `terraform init`. Run `terraform plan` and `terraform apply` from a stack directory.

## Environment variables

Secrets never enter git. Terraform reads them from `TF_VAR_*` and provider variables, Ansible reads them with the env lookup.

| Used by | Variables |
| --- | --- |
| Terraform, all stacks | `TF_CLOUD_ORGANIZATION`, `TF_TOKEN_app_terraform_io` |
| Tailscale provider | `TAILSCALE_OAUTH_CLIENT_ID`, `TAILSCALE_OAUTH_CLIENT_SECRET`, `TAILSCALE_TAILNET` |
| Cloudflare stacks | `CLOUDFLARE_API_TOKEN`, `TF_VAR_account_id`, `TF_VAR_zone_id` |
| prod/aws | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |
| prod/gcp | `GOOGLE_CREDENTIALS` |
| prod/contabo | `CNTB_OAUTH2_CLIENT_ID`, `CNTB_OAUTH2_CLIENT_SECRET`, `CNTB_OAUTH2_USER`, `CNTB_OAUTH2_PASS` |
| prod/bytebase | `BYTEBASE_URL`, `BYTEBASE_SERVICE_ACCOUNT`, `BYTEBASE_SERVICE_KEY`, `TF_VAR_ops_api_db_username`, `TF_VAR_ops_api_db_password` |
| Ansible | `CLOUDFLARE_DNS_API_TOKEN`, `CLOUDFLARE_TUNNEL_TOKEN`, `BYTEBASE_POSTGRES_PASSWORD`, `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `OPS_DATABASE_URL`, and `TAILSCALE_AUTH_KEY` only for a host that cloud-init did not join |
| GitHub Actions only | `TS_OAUTH_CLIENT_ID`, `TS_OAUTH_SECRET` (a Tailscale OAuth client that mints `tag:ci` keys) |

The GitHub workflows read the same values from repository secrets and variables. See `.github/workflows/terraform.yml` and `ansible.yml` for the secret names.

## Runbooks

- [Bootstrap](docs/runbooks/bootstrap.md)
- [Move the host to another cloud](docs/runbooks/move-host.md)
- [Add a database to Bytebase](docs/runbooks/add-database.md)
- [Restore Bytebase from a backup](docs/runbooks/restore-bytebase.md)
