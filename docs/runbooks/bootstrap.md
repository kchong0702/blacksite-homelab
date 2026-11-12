# Bootstrap

Run once, in this order. Nothing here is applied until you have the accounts.

1. Create the HCP Terraform organization and seven workspaces: `global-tailscale`, `global-cloudflare`, `prod-aws`, `prod-gcp`, `prod-contabo`, `prod-cloudflare`, `prod-bytebase`. Set each workspace's execution mode to Local. Export `TF_CLOUD_ORGANIZATION` and `TF_TOKEN_app_terraform_io`.
2. Create a Tailscale OAuth client with the auth keys, ACL, DNS and devices scopes and export `TAILSCALE_OAUTH_CLIENT_ID`, `TAILSCALE_OAUTH_CLIENT_SECRET` and `TAILSCALE_TAILNET`. Apply `terraform/environments/global/tailscale`. If the tailnet already has a policy, import it first with `terraform import module.tailnet.tailscale_acl.this acl`.
3. Export `CLOUDFLARE_API_TOKEN`, `TF_VAR_account_id` and `TF_VAR_zone_id`. Apply `terraform/environments/global/cloudflare`.
4. Pick the cloud. In `terraform/environments/prod/<cloud>/terraform.tfvars` set `hosts = { blacksite = { size = "medium" } }`, export that cloud's credentials and apply. For Contabo, first fill `product_ids` and `image_id` from `cntb get products` and `cntb get images`. cloud-init joins the VM to the tailnet as `blacksite` with `tag:server`.
5. Apply `terraform/environments/prod/cloudflare`. It needs the VM on the tailnet because it reads the device's IP for the `ops` and `bytebase` records. Read `terraform output -raw tunnel_token` and `terraform output -raw caddy_dns_token`.
6. Create an R2 API token for the `backups` bucket in the Cloudflare dashboard.
7. Export the Ansible variables from the README, then from `ansible/` run `ansible-galaxy collection install -r requirements.yml` and `ansible-playbook playbooks/site.yml --user root`.
8. Open `https://bytebase.kelvinchong.dev` over the tailnet, finish the setup, and create a service account with the Workspace Admin role. Export `BYTEBASE_URL`, `BYTEBASE_SERVICE_ACCOUNT` and `BYTEBASE_SERVICE_KEY`.
9. Add the Supabase database as in [add-database](add-database.md), then apply `terraform/environments/prod/bytebase`.

In GitHub, add the same values as repository secrets and variables so the workflows can run.
