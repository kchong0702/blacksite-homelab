output "instance_ids" {
  description = "Lighthouse instance ID per host."
  value       = { for name, host in module.compute : name => host.instance_id }
}
