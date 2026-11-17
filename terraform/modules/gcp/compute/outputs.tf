output "instance_id" {
  description = "Compute Engine instance ID."
  value       = google_compute_instance.this.id
}
