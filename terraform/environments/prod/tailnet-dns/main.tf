locals {
  tailnet_ipv4 = one([for address in data.tailscale_device.host.addresses : address if can(cidrnetmask("${address}/32"))])
}

data "tailscale_device" "host" {
  hostname = var.tailnet_host
  wait_for = "60s"
}

module "dns" {
  source = "../../../modules/cloudflare/dns"

  zone_id = var.zone_id

  records = {
    "${var.ops_subdomain}.${var.domain}"      = local.tailnet_ipv4
    "${var.bytebase_subdomain}.${var.domain}" = local.tailnet_ipv4
  }
}
