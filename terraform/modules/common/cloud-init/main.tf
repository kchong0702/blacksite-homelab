locals {
  rendered = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    hostname           = var.hostname
    tailscale_auth_key = var.tailscale_auth_key
    tags               = var.tags
    harden_public_ip   = var.harden_public_ip
  })
}
