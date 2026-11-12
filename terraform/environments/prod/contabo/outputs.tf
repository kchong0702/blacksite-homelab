output "instance_ids" {
  value = { for name, host in module.compute : name => host.instance_id }
}
