output "hostnames" {
  value = keys(cloudflare_dns_record.this)
}
