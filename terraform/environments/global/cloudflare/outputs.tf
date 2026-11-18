output "zone_settings" {
  description = "Value of each zone setting, by setting ID."
  value       = { for id, setting in cloudflare_zone_setting.this : id => setting.value }
}
