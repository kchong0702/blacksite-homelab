output "rendered" {
  description = "Rendered cloud-init config, passed to the instance as user data."
  value       = local.rendered
  sensitive   = true
}
