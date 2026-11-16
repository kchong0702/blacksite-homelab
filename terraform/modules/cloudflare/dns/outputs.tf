output "hostnames" {
  description = "Hostnames of the records created."
  value       = keys(cloudflare_dns_record.this)
}
