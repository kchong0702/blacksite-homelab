provider "google" {
  project = var.project_id
  region  = var.region
}

provider "tailscale" {}

locals {
  machine_types = {
    small  = "e2-small"
    medium = "e2-medium"
  }
}

module "network" {
  source = "../../../modules/gcp/network"

  name   = "blacksite"
  region = var.region
}

resource "tailscale_tailnet_key" "host" {
  for_each = var.hosts

  reusable      = false
  preauthorized = true
  expiry        = 3600
  tags          = ["tag:server"]
}

module "cloud_init" {
  for_each = var.hosts

  source = "../../../modules/common/cloud-init"

  hostname           = each.key
  tailscale_auth_key = tailscale_tailnet_key.host[each.key].key
  tags               = ["tag:server"]
}

module "compute" {
  for_each = var.hosts

  source = "../../../modules/gcp/compute"

  name          = each.key
  machine_type  = local.machine_types[each.value.size]
  zone          = var.zone
  subnetwork_id = module.network.subnetwork_id
  user_data     = module.cloud_init[each.key].rendered
}
