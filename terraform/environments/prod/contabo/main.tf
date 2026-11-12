provider "contabo" {}

provider "tailscale" {}

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
  harden_public_ip   = true
}

module "compute" {
  for_each = var.hosts

  source = "../../../modules/contabo/compute"

  name       = each.key
  product_id = var.product_ids[each.value.size]
  image_id   = var.image_id
  region     = var.region
  user_data  = module.cloud_init[each.key].rendered
}
