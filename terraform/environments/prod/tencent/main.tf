module "network" {
  source = "../../../modules/tencent/network"

  name = "blacksite"
}

resource "tailscale_tailnet_key" "host" {
  for_each = var.hosts

  reusable      = false
  preauthorized = true
  expiry        = 86400
  tags          = ["tag:server"]
}

module "compute" {
  for_each = var.hosts

  source = "../../../modules/tencent/compute"

  name                 = each.key
  bundle_id            = var.bundle_ids[each.value.size]
  blueprint_id         = var.blueprint_id
  firewall_template_id = module.network.firewall_template_id
  bootstrap_script     = <<-EOT
    #!/bin/bash
    set -euo pipefail
    hostnamectl set-hostname ${each.key}
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up --auth-key=${tailscale_tailnet_key.host[each.key].key} --hostname=${each.key} --advertise-tags=tag:server --ssh --accept-dns=false
  EOT
}
