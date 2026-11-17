resource "google_compute_network" "this" {
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = var.name
  region        = var.region
  network       = google_compute_network.this.id
  ip_cidr_range = var.ip_cidr_range
}
