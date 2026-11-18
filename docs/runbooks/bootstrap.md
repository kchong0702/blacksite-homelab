# Bootstrap

Run these steps once, in order. Save every value as the secret or variable named under [GitHub repository settings](../../README.md#github-repository-settings). Steps 1 to 5 only create credentials, and the Deploy workflow does every apply. Leave `ACTIVE_CLOUD` unset until step 4, so Deploy skips until the credentials exist.

1. Create the HCP Terraform organization and eight workspaces: `global-tailscale`, `global-cloudflare`, `prod-cloudflare`, `prod-aws`, `prod-gcp`, `prod-contabo`, `prod-tencent`, `prod-bytebase`. Set each workspace's execution mode to Local. Save the organization name as `TF_CLOUD_ORGANIZATION` and an API token as `TF_TOKEN_APP_TERRAFORM_IO`.
2. In the Tailscale admin console create a first OAuth client with the `policy_file`, `dns` and `feature_settings` scopes. Save it as `TAILSCALE_OAUTH_CLIENT_ID` and `TAILSCALE_OAUTH_CLIENT_SECRET`, and the tailnet name as `TAILSCALE_TAILNET`. This client only lasts until step 7, because an OAuth client can only pick tags that already exist in the policy.

   If the tailnet already has a policy, import it from `terraform/environments/global/tailscale` with `terraform import module.tailnet.tailscale_acl.this acl`. Export the variables from the README's Setup section first. Import only records state, so it doesn't break the rule that Deploy does every apply.
3. Create the Cloudflare API token from the Create Additional Tokens template, because only that template carries User > API Tokens > Edit, which `cloudflare_api_token` needs. Add these permissions.
   - Account > Cloudflare Pages > Edit
   - Account > Workers R2 Storage > Edit
   - Account > Cloudflare Tunnel > Edit
   - Zone > Zone Settings > Edit
   - Zone > DNS > Edit
   - Zone > Zone > Read

   Scope the token to the account and to the `kelvinchong.dev` zone. The provider docs call the Edit level Write. Save it as `CLOUDFLARE_API_TOKEN`, with `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_ZONE_ID`.

   If a `renderverse` Pages project, its custom domains or DNS records for the apex, `www` or `ezbot` already exist, import them from `terraform/environments/prod/cloudflare` with the commands below. Otherwise delete the old records in the dashboard. R2 creates the `assets` record itself, so delete an existing `assets` record rather than importing it.

   ```
   terraform import 'module.pages.cloudflare_pages_project.this' '<account_id>/renderverse'
   terraform import 'module.pages.cloudflare_pages_domain.this["kelvinchong.dev"]' '<account_id>/renderverse/kelvinchong.dev'
   terraform import 'module.pages.cloudflare_pages_domain.this["www.kelvinchong.dev"]' '<account_id>/renderverse/www.kelvinchong.dev'
   terraform import 'module.pages.cloudflare_dns_record.this["kelvinchong.dev"]' '<zone_id>/<record_id>'
   terraform import 'module.pages.cloudflare_dns_record.this["www.kelvinchong.dev"]' '<zone_id>/<record_id>'
   terraform import 'module.tunnel.cloudflare_dns_record.this["ezbot.kelvinchong.dev"]' '<zone_id>/<record_id>'
   ```

   Find each record id with `GET /zones/<zone_id>/dns_records?name=<hostname>` or in the dashboard URL of the record.
4. Pick the cloud. Save its credentials from the table in the README, then set `ACTIVE_CLOUD` to `aws`, `gcp`, `contabo` or `tencent`. For GCP, first create a project, enable the Compute Engine API and save the project id as `GCP_PROJECT_ID`. The repo is public, so the id stays out of `terraform.tfvars`. Contabo and Tencent need no lookups. Contabo uses Cloud VPS 4 (`V153`) and the standard `ubuntu-24.04` image. Tencent uses the Ubuntu 24.04 blueprint and picks the 2 vCPU, 4 GB Starter bundle by its specs.
5. Save `BYTEBASE_POSTGRES_PASSWORD`, generated with `openssl rand -base64 32`, and `OPS_DATABASE_URL`, the Supabase session pooler URL of the ops database.
6. In the repository's Actions tab, run the Deploy workflow. It applies the tailnet policy, device approval, the Cloudflare zone settings, R2, the tunnel, Pages and the Caddy and backup tokens. There is no host yet, so `configuration` and `databases` skip.

   Device approval is now on. A device you log in to the tailnet yourself waits until an admin approves it under Machines. Hosts and CI join with pre-approved keys and skip this.
7. Step 6 created `tag:server`, `tag:infra-ci` and `tag:deploy`, so create the long-lived Tailscale OAuth clients.
   1. The Terraform client, with the scopes `policy_file`, `dns`, `feature_settings`, `devices:core:read` and `auth_keys` with `tag:server`. Save it over `TAILSCALE_OAUTH_CLIENT_ID` and `TAILSCALE_OAUTH_CLIENT_SECRET`, then delete the client from step 2.
   2. The CI client, with the `auth_keys` scope and `tag:infra-ci`. Save it as `TS_OAUTH_CLIENT_ID` and `TS_OAUTH_SECRET`. CI joined as `tag:infra-ci` can SSH in as `root`.
   3. For each app repo that deploys to the VM, such as renderverse, a client with the `auth_keys` scope and `tag:deploy`, saved in that repo's GitHub secrets. CI joined as `tag:deploy` can SSH in only as `deploy`.
8. Open a pull request that sets `hosts = { blacksite = { size = "medium", subdomains = ["ops", "bytebase"] } }` in the active cloud's `terraform.tfvars`, check the plan and merge it. Deploy creates the VM, which joins the tailnet as `blacksite` with `tag:server` through cloud-init, or a TencentCloud Automation Tools command on Lighthouse. It then points the `ops` and `bytebase` records at the VM's tailnet IP and runs `site.yml`.
9. Open `https://bytebase.kelvinchong.dev` over the tailnet and sign up. The first account becomes the workspace admin. Create a service account with the Workspace Admin role and save it as `BYTEBASE_SERVICE_ACCOUNT` and `BYTEBASE_SERVICE_KEY`, and set the `BYTEBASE_URL` variable.
10. Register the ops database with [add-database](add-database.md). The pull request it opens is the first one where `databases` runs.

To SSH in yourself, run `ssh root@blacksite` from a tailnet device. Admins use Tailscale SSH in check mode, so Tailscale asks you to approve the login in the browser.
