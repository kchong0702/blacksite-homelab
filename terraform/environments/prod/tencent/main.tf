module "network" {
  source = "../../../modules/tencent/network"

  name = "blacksite"
}

data "tencentcloud_lighthouse_bundle" "linux" {
  limit = 100

  filters {
    name   = "support-platform-type"
    values = ["LINUX_UNIX"]
  }
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
  bundle_id            = one([for bundle in data.tencentcloud_lighthouse_bundle.linux.bundle_set : bundle.bundle_id if bundle.cpu == 2 && bundle.memory == 4 && bundle.system_disk_size == 60 && bundle.internet_max_bandwidth_out == 30])
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

module "dns" {
  for_each = var.hosts

  source = "../../../modules/cloudflare/dns"

  tailnet_host = each.key
  zone_id      = var.zone_id
  records      = [for subdomain in each.value.subdomains : "${subdomain}.${var.domain}"]

  depends_on = [module.compute]
}
