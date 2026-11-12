# Move the host to another cloud

1. Confirm a recent backup exists in the `backups` R2 bucket. If not, run `systemctl start pg-backup` on the host and check the bucket.
2. In the old cloud's `terraform.tfvars` set `hosts = {}` and apply. This destroys the VM and everything on its disk, so the backup in step 1 must exist.
3. In the new cloud's `terraform.tfvars` set `hosts = { blacksite = { size = "medium" } }` and apply. cloud-init joins the VM to the tailnet under the same name. Delete the stale `blacksite` device in the Tailscale admin console first if the new one comes up as `blacksite-1`.
4. From `ansible/` run `ansible-playbook playbooks/site.yml --user root`.
5. Restore Bytebase with [restore-bytebase](restore-bytebase.md).
6. Apply `terraform/environments/prod/cloudflare` again so the `ops` and `bytebase` A records follow the new tailnet IP.
