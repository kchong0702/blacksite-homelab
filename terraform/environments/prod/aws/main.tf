provider "aws" {
  region = var.region
}

provider "tailscale" {}

locals {
  instance_types = {
    small  = "t3.small"
    medium = "t3.medium"
  }
}

module "network" {
  source = "../../../modules/aws/network"

  name = "blacksite"
}

resource "tailscale_tailnet_key" "host" {
  for_each = var.hosts

  reusable      = false
  preauthorized = true
  expiry        = 86400
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

  source = "../../../modules/aws/compute"

  name               = each.key
  instance_type      = local.instance_types[each.value.size]
  security_group_ids = [module.network.security_group_id]
  user_data          = module.cloud_init[each.key].rendered
}
