output "instance_name" {
  description = "Resource name of the ops-api instance in Bytebase."
  value       = bytebase_instance.ops_api.name
}
