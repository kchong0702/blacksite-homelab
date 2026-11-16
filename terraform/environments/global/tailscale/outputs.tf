output "acl_id" {
  description = "ID of the tailscale_acl resource that holds the tailnet policy."
  value       = module.tailnet.acl_id
}
