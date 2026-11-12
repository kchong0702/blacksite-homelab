resource "cloudflare_pages_project" "this" {
  account_id        = var.account_id
  name              = var.name
  production_branch = var.production_branch
}

resource "cloudflare_pages_domain" "this" {
  for_each = toset(var.domains)

  account_id   = var.account_id
  project_name = cloudflare_pages_project.this.name
  name         = each.key
}

resource "cloudflare_dns_record" "this" {
  for_each = toset(var.domains)

  zone_id = var.zone_id
  name    = each.key
  type    = "CNAME"
  content = cloudflare_pages_project.this.subdomain
  ttl     = 1
  proxied = true
}
