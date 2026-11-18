resource "cloudflare_dns_record" "this" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.key
  type    = "A"
  content = each.value
  ttl     = 1
  proxied = false
}
