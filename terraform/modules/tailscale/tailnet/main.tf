resource "tailscale_acl" "this" {
  acl = jsonencode({
    tagOwners = {
      "tag:server" = ["autogroup:admin"]
      "tag:ci"     = ["autogroup:admin"]
    }

    grants = [
      {
        src = ["autogroup:member"]
        dst = ["tag:server"]
        ip  = ["tcp:443"]
      },
      {
        src = ["autogroup:admin"]
        dst = ["tag:server"]
        ip  = ["tcp:22"]
      },
      {
        src = ["tag:ci"]
        dst = ["tag:server"]
        ip  = ["tcp:22", "tcp:443"]
      },
    ]

    ssh = [
      {
        action = "check"
        src    = ["autogroup:admin"]
        dst    = ["tag:server"]
        users  = ["autogroup:nonroot", "root"]
      },
      {
        action = "accept"
        src    = ["tag:ci"]
        dst    = ["tag:server"]
        users  = ["deploy", "root"]
      },
    ]
  })
}

resource "tailscale_dns_configuration" "this" {
  magic_dns          = true
  override_local_dns = true

  dynamic "nameservers" {
    for_each = var.nameservers

    content {
      address = nameservers.value
    }
  }
}
