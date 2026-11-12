resource "cloudflare_r2_bucket" "this" {
  for_each = var.buckets

  account_id = var.account_id
  name       = each.key
}

resource "cloudflare_r2_bucket_cors" "this" {
  for_each = { for name, bucket in var.buckets : name => bucket if length(bucket.cors_origins) > 0 }

  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.this[each.key].name

  rules = [{
    allowed = {
      origins = each.value.cors_origins
      methods = each.value.cors_methods
      headers = each.value.cors_headers
    }
  }]
}

resource "cloudflare_r2_custom_domain" "this" {
  for_each = { for name, bucket in var.buckets : name => bucket if bucket.public_domain != null }

  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.this[each.key].name
  zone_id     = var.zone_id
  domain      = each.value.public_domain
  enabled     = true
}
