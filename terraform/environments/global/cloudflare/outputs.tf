output "zone_settings" {
  value = { for id, setting in cloudflare_zone_setting.this : id => setting.value }
}
