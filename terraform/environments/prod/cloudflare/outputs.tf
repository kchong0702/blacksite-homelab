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

output "backups_access_key_id" {
  description = "S3 access key ID for the backups bucket, the ID of the bucket-scoped token."
  value       = cloudflare_api_token.backups.id
  sensitive   = true
}

output "backups_secret_access_key" {
  description = "S3 secret access key for the backups bucket, the SHA-256 of the token value."
  value       = sha256(cloudflare_api_token.backups.value)
  sensitive   = true
}
