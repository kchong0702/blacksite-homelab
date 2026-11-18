data "tailscale_device" "this" {
  hostname = var.tailnet_host
  wait_for = "300s"
}

resource "cloudflare_dns_record" "this" {
  for_each = toset(var.records)

  zone_id = var.zone_id
  name    = each.key
  type    = "A"
  content = one([for address in data.tailscale_device.this.addresses : address if can(cidrnetmask("${address}/32"))])
  ttl     = 1
  proxied = false
}
