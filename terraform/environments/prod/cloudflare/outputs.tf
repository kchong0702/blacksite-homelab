output "hostnames" {
  value = {
    ezbot    = local.ezbot_host
    ops      = local.ops_host
    bytebase = local.bytebase_host
    assets   = local.assets_host
  }
}

output "tunnel_token" {
  value     = module.tunnel.token
  sensitive = true
}

output "caddy_dns_token" {
  value     = cloudflare_api_token.caddy_dns.value
  sensitive = true
}
