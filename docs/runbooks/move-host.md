# Move the host to another cloud

1. Confirm a recent backup exists in the `backups` R2 bucket. If not, run `systemctl start pg-backup` on the host and check the bucket.
2. On the old host stop the compose stacks for caddy, cloudflared, bytebase and the renderverse app. Run `tailscale logout`, then delete the old `blacksite` device in the Tailscale admin console. This is mandatory for Contabo, because destroy only cancels the contract and the VPS keeps running until the term ends. Two cloudflared connectors on one tunnel would split ezbot traffic.
3. In the old cloud's `terraform.tfvars` set `hosts = {}` and apply. This destroys the VM and everything on its disk, so the backup in step 1 must exist.
4. In the new cloud's `terraform.tfvars` set `hosts = { blacksite = { size = "medium" } }` and apply. cloud-init joins the VM to the tailnet under the same name.
5. From `ansible/` run `ansible-playbook playbooks/site.yml --user root`.
6. Restore Bytebase with [restore-bytebase](restore-bytebase.md).
7. Apply `terraform/environments/prod/cloudflare` again so the `ops` and `bytebase` A records follow the new tailnet IP.

If you ever replace the instance in place, add `-replace='tailscale_tailnet_key.host["blacksite"]'` to the plan and apply, because the single-use auth key is already spent.
