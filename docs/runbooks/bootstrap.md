# Bootstrap

Run these steps once, in order.

1. Create the HCP Terraform organization and eight workspaces: `global-tailscale`, `global-cloudflare`, `prod-aws`, `prod-gcp`, `prod-contabo`, `prod-tencent`, `prod-cloudflare`, `prod-bytebase`. Set each workspace's execution mode to Local. Export `TF_CLOUD_ORGANIZATION` and `TF_TOKEN_app_terraform_io`.
2. Set up Tailscale in two rounds, because an OAuth client can only pick tags that already exist in the policy.
   1. In the Tailscale admin console create a first OAuth client with only the `policy_file` and `dns` scopes. Export `TAILSCALE_OAUTH_CLIENT_ID`, `TAILSCALE_OAUTH_CLIENT_SECRET` and `TAILSCALE_TAILNET`.
   2. If the tailnet already has a policy, import it with `terraform import module.tailnet.tailscale_acl.this acl`. Then apply `terraform/environments/global/tailscale`. This creates `tag:server`, `tag:infra-ci` and `tag:deploy`.
   3. Create the Terraform client used from now on with the scopes `policy_file`, `dns`, `devices:core:read` and `auth_keys` with `tag:server`. Export its id and secret in place of the first client, then delete the first client.
   4. Create a separate CI client with the `auth_keys` scope and `tag:infra-ci`. Save it as this repo's `TS_OAUTH_CLIENT_ID` and `TS_OAUTH_SECRET` GitHub secrets. CI joined as `tag:infra-ci` can SSH in as `root`.
   5. For each app repo that deploys to the VM, such as renderverse, create its own client with the `auth_keys` scope and `tag:deploy`. Save it in that repo's GitHub secrets. CI joined as `tag:deploy` can SSH in only as `deploy`.
3. Create the Cloudflare API token from the Create Additional Tokens template, because only that template carries User > API Tokens > Edit, which `cloudflare_api_token` needs. Add these permissions.
   - Account > Cloudflare Pages > Edit
   - Account > Workers R2 Storage > Edit
   - Account > Cloudflare Tunnel > Edit
   - Zone > Zone Settings > Edit
   - Zone > DNS > Edit
   - Zone > Zone > Read

   Scope the token to the account and to the `kelvinchong.dev` zone. The provider docs call the Edit level Write. Export `CLOUDFLARE_API_TOKEN`, `TF_VAR_account_id` and `TF_VAR_zone_id`. Apply `terraform/environments/global/cloudflare`.
4. Pick the cloud.
   1. Set the repository variable `ACTIVE_CLOUD` to `aws`, `gcp`, `contabo` or `tencent`. The Terraform workflow only runs that cloud's stack. Until this variable is set, the Terraform and Ansible workflows skip.
   2. For GCP, create a project and enable the Compute Engine API. Export its id as `TF_VAR_project_id` and save it as the `GCP_PROJECT_ID` repository variable. The repo is public, so the id stays out of `terraform.tfvars`. Contabo and Tencent need no lookups. Contabo uses Cloud VPS 4 (`V153`) and the standard `ubuntu-24.04` image. Tencent uses the Ubuntu 24.04 blueprint and picks the 2 vCPU, 4 GB Starter bundle by its specs.
   3. In that one cloud's `terraform.tfvars` set `hosts = { blacksite = { size = "medium" } }`, export the cloud's credentials and apply. cloud-init, or a TencentCloud Automation Tools command on Lighthouse, joins the VM to the tailnet as `blacksite` with `tag:server`.
5. Apply `terraform/environments/prod/cloudflare`. It needs the VM on the tailnet because it reads the device's IP for the `ops` and `bytebase` records. Read `terraform output -raw tunnel_token` and `terraform output -raw caddy_dns_token`.

   If a `renderverse` Pages project, its custom domains or DNS records for the apex, `www`, `ezbot` or `assets` already exist, import them first with the commands below. Otherwise delete the old records in the dashboard. R2 creates the `assets` record itself, so delete an existing `assets` record rather than importing it.

   ```
   terraform import 'module.pages.cloudflare_pages_project.this' '<account_id>/renderverse'
   terraform import 'module.pages.cloudflare_pages_domain.this["kelvinchong.dev"]' '<account_id>/renderverse/kelvinchong.dev'
   terraform import 'module.pages.cloudflare_pages_domain.this["www.kelvinchong.dev"]' '<account_id>/renderverse/www.kelvinchong.dev'
   terraform import 'module.pages.cloudflare_dns_record.this["kelvinchong.dev"]' '<zone_id>/<record_id>'
   terraform import 'module.pages.cloudflare_dns_record.this["www.kelvinchong.dev"]' '<zone_id>/<record_id>'
   terraform import 'module.tunnel.cloudflare_dns_record.this["ezbot.kelvinchong.dev"]' '<zone_id>/<record_id>'
   ```

   Find each record id with `GET /zones/<zone_id>/dns_records?name=<hostname>` or in the dashboard URL of the record.
6. Create an R2 API token for the `backups` bucket in the Cloudflare dashboard.
7. Admins reach the VM through Tailscale SSH in check mode. Run `ssh root@blacksite` once interactively and approve the login. Then export the Ansible variables from the README and run `ansible-galaxy collection install -r requirements.yml` and `ansible-playbook playbooks/site.yml --user root` from `ansible/`.
8. Open `https://bytebase.kelvinchong.dev` over the tailnet, finish the setup, and create a service account with the Workspace Admin role. Export `BYTEBASE_URL`, `BYTEBASE_SERVICE_ACCOUNT` and `BYTEBASE_SERVICE_KEY`.
9. Add the Supabase database as in [add-database](add-database.md), then apply `terraform/environments/prod/bytebase`.

In GitHub, add every variable and secret listed under [GitHub repository settings](../../README.md#github-repository-settings) so the workflows can run.
