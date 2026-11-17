output "instance_id" {
  description = "Contabo instance ID."
  value       = contabo_instance.this.id
}

output "ipv4" {
  description = "Public IPv4 address of the instance."
  value       = contabo_instance.this.ip_config[0].v4[0].ip
}
