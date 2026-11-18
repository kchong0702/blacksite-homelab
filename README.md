# blacksite-homelab

Infrastructure for one tailnet VM that hosts Bytebase and the renderverse backend services, plus the Cloudflare side of kelvinchong.dev. The VM can sit on AWS, GCP, Contabo or Tencent Cloud Lighthouse and moves between them as credits run out.

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
| Terraform | Anything behind an API: the VM and its tailnet DNS records, the cloud network, Tailscale policy and DNS, Cloudflare Pages, R2 and the backup token, tunnel, DNS and zone settings, Bytebase instances |
| Ansible | Anything on the VM's disk: packages, firewall, Tailscale join, Docker, Caddy, cloudflared, Bytebase, the backup timer |
| renderverse CI | The app containers in `/srv/renderverse`. It joins the tailnet as `tag:deploy` and logs in as `deploy`. This repo never runs the app compose |

## Layout

```
terraform/modules/        one module per resource group, no provider config
terraform/environments/   one stack per HCP workspace: global/{tailscale,cloudflare}, prod/{cloudflare,aws,gcp,contabo,tencent,bytebase}
ansible/                  hosts.yml, group_vars/<group>/<role>.yml, playbooks/site.yml with one play per group, one role per concern
docs/runbooks/            bootstrap, move-host, add-database, restore-bytebase
```

Only one of `prod/aws`, `prod/gcp`, `prod/contabo` and `prod/tencent` holds a host at a time. Each takes `hosts = { <name> = { size = "small" | "medium", subdomains = [...] } }`. The stack creates the VM, waits for it to join the tailnet, and points `<subdomain>.kelvinchong.dev` at its tailnet IP.

## How changes reach production

Every apply runs in GitHub Actions. Open a pull request, read the plan in its checks, and merge. Never run `terraform apply` or `ansible-playbook` against production from a laptop, because the next Deploy run applies `main` and reverts anything that isn't on it. State commands such as `terraform import` are the exception, and the bootstrap runbook says when to use them.

| Workflow | Runs on | What it does |
| --- | --- | --- |
| Plan | Pull requests that touch `terraform/` | `terraform plan` for `global/tailscale`, `global/cloudflare`, `prod/cloudflare` and `prod/<ACTIVE_CLOUD>`, and for `prod/bytebase` once there is a host and a Bytebase service account. Each plan goes to the run summary. Skips pull requests from forks |
| Deploy | Merges to `main` that touch `terraform/` or `ansible/`, and manual runs | Applies the four stacks one at a time and stops at the first failure. Then runs `site.yml` over Tailscale SSH with the tunnel token, Caddy DNS token and R2 backup keys read from `prod/cloudflare`'s outputs, then applies `prod/bytebase`. The Ansible and Bytebase steps skip while the active cloud has no host, and the Bytebase step also skips until `BYTEBASE_SERVICE_KEY` is set |
| Backup | Manual runs | Runs `playbooks/backup.yml` and fails if a dump or the upload fails |
| Pre-commit, Commit Policy | Every pull request and push | Lint, formatting and commit message checks |

Plan and Deploy share `reusable-terraform.yml`, which holds the stack credentials and the plan and apply jobs, and `reusable-gates.yml`, which counts hosts and checks for the Bytebase service account. Deploy and Backup run in the `production` environment, only from `main`, and never at the same time. Every action is pinned to a commit hash, and Dependabot opens a weekly pull request for action and Terraform provider updates.

## Setup

```
mise install
pre-commit install
```

Each Terraform stack runs in an HCP Terraform workspace named `<scope>-<stack>` in Local execution mode. To plan from a laptop, export `TF_CLOUD_ORGANIZATION`, `TF_TOKEN_app_terraform_io` and the provider variables the Deploy workflow sets for that stack, then run `terraform init` and `terraform plan` in the stack directory.

## GitHub repository settings

Deploy and Backup read every value below from the repository's Settings > Secrets and variables > Actions. Secrets never enter git. A missing value doesn't stop a run from starting. The step that needs it fails instead, so check this list when you set up the repo or rotate a credential.

The Cloudflare tunnel token, the Caddy DNS token and the R2 backup keys are not in this list. Terraform creates them in `prod/cloudflare`, and Deploy reads them from its outputs.

### Variables

| Name | Value | Where it comes from |
| --- | --- | --- |
| `ACTIVE_CLOUD` | `aws`, `gcp`, `contabo` or `tencent` | The cloud the host runs on. Deploy and Backup skip until it is set |
| `TF_CLOUD_ORGANIZATION` | HCP Terraform organization name | Bootstrap step 1 |
| `TAILSCALE_TAILNET` | Tailnet name | Tailscale admin console, Settings > General |
| `BYTEBASE_URL` | `https://bytebase.kelvinchong.dev` | Fixed |
| `GCP_PROJECT_ID` | GCP project id, fed to `TF_VAR_project_id` | Bootstrap step 4. Only when `ACTIVE_CLOUD` is `gcp` |

### Secrets

| Name | Feeds | Where it comes from |
| --- | --- | --- |
| `TF_TOKEN_APP_TERRAFORM_IO` | `TF_TOKEN_app_terraform_io` | An HCP Terraform user or team API token, bootstrap step 1 |
| `TAILSCALE_OAUTH_CLIENT_ID`, `TAILSCALE_OAUTH_CLIENT_SECRET` | Tailscale provider | The Terraform OAuth client, bootstrap steps 2 and 7 |
| `TS_OAUTH_CLIENT_ID`, `TS_OAUTH_SECRET` | `tailscale/github-action` | The `tag:infra-ci` OAuth client, bootstrap step 7 |
| `CLOUDFLARE_API_TOKEN` | Cloudflare provider | The token from bootstrap step 3 |
| `CLOUDFLARE_ACCOUNT_ID`, `CLOUDFLARE_ZONE_ID` | `TF_VAR_account_id`, `TF_VAR_zone_id`, and `R2_ACCOUNT_ID` for the backup timer | Cloudflare dashboard, the `kelvinchong.dev` zone overview |
| `BYTEBASE_POSTGRES_PASSWORD` | Bytebase's own Postgres, through Ansible | Generate one, for example with `openssl rand -base64 32` |
| `OPS_DATABASE_URL` | The backup timer, through Ansible | The full Supabase session pooler connection URL of the ops database |
| `BYTEBASE_SERVICE_ACCOUNT`, `BYTEBASE_SERVICE_KEY` | Bytebase provider | The service account from bootstrap step 9 |
| `OPS_API_DB_USERNAME`, `OPS_API_DB_PASSWORD` | `TF_VAR_ops_api_db_username`, `TF_VAR_ops_api_db_password` | The Supabase pooler user from [add-database](docs/runbooks/add-database.md) |

Only the active cloud's credentials are needed. Add the others when you move the host.

| `ACTIVE_CLOUD` | Secrets | Where they come from |
| --- | --- | --- |
| `aws` | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | An IAM user's access key |
| `gcp` | `GOOGLE_CREDENTIALS` | A service account JSON key in the project |
| `contabo` | `CNTB_OAUTH2_CLIENT_ID`, `CNTB_OAUTH2_CLIENT_SECRET`, `CNTB_OAUTH2_USER`, `CNTB_OAUTH2_PASS` | Contabo Customer Control Panel, API |
| `tencent` | `TENCENTCLOUD_SECRET_ID`, `TENCENTCLOUD_SECRET_KEY` | Tencent Cloud CAM, API keys |

## Runbooks

- [Bootstrap](docs/runbooks/bootstrap.md)
- [Move the host to another cloud](docs/runbooks/move-host.md)
- [Add a database to Bytebase](docs/runbooks/add-database.md)
- [Restore Bytebase from a backup](docs/runbooks/restore-bytebase.md)
