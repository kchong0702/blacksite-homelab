output "firewall_template_id" {
  description = "Firewall template the instance is created with."
  value       = tencentcloud_lighthouse_firewall_template.this.id
}
