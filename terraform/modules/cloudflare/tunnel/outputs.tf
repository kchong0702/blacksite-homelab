output "token" {
  description = "Token cloudflared uses to run the tunnel."
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
  sensitive   = true
}
