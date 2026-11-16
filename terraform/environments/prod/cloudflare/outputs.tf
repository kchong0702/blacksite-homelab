output "hostnames" {
  description = "Full hostname of each app subdomain."
  value = {
    ezbot    = local.ezbot_host
    ops      = local.ops_host
    bytebase = local.bytebase_host
    assets   = local.assets_host
  }
}

output "tunnel_token" {
  description = "Token cloudflared uses to run the tunnel."
  value       = module.tunnel.token
  sensitive   = true
}

output "caddy_dns_token" {
  description = "API token Caddy uses for DNS-01 certificates."
  value       = cloudflare_api_token.caddy_dns.value
  sensitive   = true
}
