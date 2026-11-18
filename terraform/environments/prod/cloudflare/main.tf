locals {
  ezbot_host    = "${var.ezbot_subdomain}.${var.domain}"
  ops_host      = "${var.ops_subdomain}.${var.domain}"
  bytebase_host = "${var.bytebase_subdomain}.${var.domain}"
  assets_host   = "${var.assets_subdomain}.${var.domain}"
}

data "cloudflare_api_token_permission_groups_list" "dns_write" {
  name  = "DNS%20Write"
  scope = "com.cloudflare.api.account.zone"
}

data "cloudflare_api_token_permission_groups_list" "r2_object_write" {
  name = "Workers%20R2%20Storage%20Bucket%20Item%20Write"
}

data "cloudflare_api_token_permission_groups_list" "zone_read" {
  name  = "Zone%20Read"
  scope = "com.cloudflare.api.account.zone"
}

module "storage" {
  source = "../../../modules/cloudflare/storage"

  account_id = var.account_id
  zone_id    = var.zone_id

  buckets = {
    portfolio = {
      public_domain = local.assets_host
      cors_origins  = ["https://${var.domain}", "https://www.${var.domain}"]
      cors_methods  = ["GET"]
    }
    uploads = {
      cors_origins = ["https://${local.ops_host}"]
      cors_methods = ["PUT", "GET"]
      cors_headers = ["content-type", "x-amz-checksum-sha256"]
    }
    backups = {}
  }
}

module "tunnel" {
  source = "../../../modules/cloudflare/tunnel"

  account_id = var.account_id
  zone_id    = var.zone_id
  name       = var.tailnet_host

  ingress = {
    (local.ezbot_host) = "http://127.0.0.1:8000"
  }
}

module "pages" {
  source = "../../../modules/cloudflare/pages"

  account_id = var.account_id
  zone_id    = var.zone_id
  name       = "renderverse"
  domains    = [var.domain, "www.${var.domain}"]
}

resource "cloudflare_api_token" "caddy_dns" {
  name = "caddy-dns-01"

  policies = [{
    effect = "allow"
    permission_groups = [
      { id = data.cloudflare_api_token_permission_groups_list.dns_write.result[0].id },
      { id = data.cloudflare_api_token_permission_groups_list.zone_read.result[0].id },
    ]
    resources = jsonencode({ "com.cloudflare.api.account.zone.${var.zone_id}" = "*" })
  }]
}

resource "cloudflare_api_token" "backups" {
  name = "r2-backups"

  policies = [{
    effect            = "allow"
    permission_groups = [{ id = data.cloudflare_api_token_permission_groups_list.r2_object_write.result[0].id }]
    resources         = jsonencode({ "com.cloudflare.edge.r2.bucket.${var.account_id}_default_backups" = "*" })
  }]
}
