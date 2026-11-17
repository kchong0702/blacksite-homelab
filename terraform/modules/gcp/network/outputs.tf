output "subnetwork_id" {
  description = "ID of the subnet the VMs attach to."
  value       = google_compute_subnetwork.this.id
}
