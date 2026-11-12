output "instance_id" {
  value = contabo_instance.this.id
}

output "ipv4" {
  value = contabo_instance.this.ip_config[0].v4[0].ip
}
