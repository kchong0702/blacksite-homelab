# Move the host to another cloud

1. Run the Backup workflow from the Actions tab and wait for it to pass. It fails if any dump or the upload to the `backups` R2 bucket fails.
2. SSH in to the old host and stop the compose stacks for caddy, cloudflared, bytebase and the renderverse app. Run `tailscale logout`, then delete the old `blacksite` device in the Tailscale admin console. The new VM can only take the `blacksite` name once the old device is gone, and two cloudflared connectors on one tunnel would split ezbot traffic. On Contabo this also matters because destroy only cancels the contract, and the VPS keeps running until the term ends.
3. Open a pull request that sets `hosts = {}` in the old cloud's `terraform.tfvars` and merge it. Deploy destroys the VM, everything on its disk, and its `ops` and `bytebase` records, so the backup from step 1 must exist.
4. Save the new cloud's credentials from the table in the README and set `ACTIVE_CLOUD` to the new cloud.
5. Open a pull request that sets `hosts = { blacksite = { size = "medium", subdomains = ["ops", "bytebase"] } }` in the new cloud's `terraform.tfvars` and merge it. Deploy creates the VM, points the records at its tailnet IP and runs `site.yml`. The `databases` job of this run fails, because the new Bytebase is empty and doesn't know the service account yet.
6. Restore Bytebase with [restore-bytebase](restore-bytebase.md). The dump brings back the admin, the service account and the registered databases.
7. Run the Deploy workflow from the Actions tab. `databases` now passes.

To rebuild the VM in the same cloud, follow the same steps without changing `ACTIVE_CLOUD`. Setting `hosts = {}` and then setting it back gives the new VM a fresh single-use tailnet key.
