# Bootstrap

Run these steps once, in order.

1. Create the HCP Terraform organization and seven workspaces: `global-tailscale`, `global-cloudflare`, `prod-aws`, `prod-gcp`, `prod-contabo`, `prod-cloudflare`, `prod-bytebase`. Set each workspace's execution mode to Local. Export `TF_CLOUD_ORGANIZATION` and `TF_TOKEN_app_terraform_io`.
2. Set up Tailscale in two rounds, because an OAuth client can only pick tags that already exist in the policy.
   1. In the Tailscale admin console create a first OAuth client with only the `policy_file` and `dns` scopes. Export `TAILSCALE_OAUTH_CLIENT_ID`, `TAILSCALE_OAUTH_CLIENT_SECRET` and `TAILSCALE_TAILNET`.
   2. If the tailnet already has a policy, import it with `terraform import module.tailnet.tailscale_acl.this acl`. Then apply `terraform/environments/global/tailscale`. This creates `tag:server` and `tag:ci`.
   3. Create the Terraform client used from now on with the scopes `policy_file`, `dns`, `devices:core:read` and `auth_keys` with `tag:server`. Export its id and secret in place of the first client, then delete the first client.
   4. Create a separate CI client with the `auth_keys` scope and `tag:ci`. Save it as the `TS_OAUTH_CLIENT_ID` and `TS_OAUTH_SECRET` GitHub secrets.
3. Create the Cloudflare API token from the Create Additional Tokens template, because only that template carries User > API Tokens > Edit, which `cloudflare_api_token` needs. Add these permissions.
   - Account > Cloudflare Pages > Edit
   - Account > Workers R2 Storage > Edit
   - Account > Cloudflare Tunnel > Edit
   - Zone > Zone Settings > Edit
   - Zone > DNS > Edit
   - Zone > Zone > Read

   Scope the token to the account and to the `kelvinchong.dev` zone. The provider docs call the Edit level Write. Export `CLOUDFLARE_API_TOKEN`, `TF_VAR_account_id` and `TF_VAR_zone_id`. Apply `terraform/environments/global/cloudflare`.
4. Pick the cloud.
   1. Set the repository variable `ACTIVE_CLOUD` to `aws`, `gcp` or `contabo`. The Terraform workflow only runs that cloud's stack. Until this variable is set, the Terraform and Ansible workflows skip.
   2. For GCP, create a project, enable the Compute Engine API and put the project id in `terraform/environments/prod/gcp/terraform.tfvars`. For Contabo, fill `product_ids` and `image_id` from `cntb get products` and `cntb get images`.
   3. In that one cloud's `terraform.tfvars` set `hosts = { blacksite = { size = "medium" } }`, export the cloud's credentials and apply. cloud-init joins the VM to the tailnet as `blacksite` with `tag:server`.
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

In GitHub, add the same values so the workflows can run. Repository variables hold the non-secret settings.

- `TF_CLOUD_ORGANIZATION`
- `TAILSCALE_TAILNET`
- `BYTEBASE_URL`
- `ACTIVE_CLOUD`

Everything else is a repository secret. `.github/workflows/terraform.yml` and `ansible.yml` list the secret names.
