provider "tailscale" {}

module "tailnet" {
  source = "../../../modules/tailscale/tailnet"

  nameservers = var.nameservers
}
