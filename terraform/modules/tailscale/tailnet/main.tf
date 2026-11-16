resource "tailscale_acl" "this" {
  acl = jsonencode({
    tagOwners = {
      "tag:server"   = ["autogroup:admin"]
      "tag:infra-ci" = ["autogroup:admin"]
      "tag:deploy"   = ["autogroup:admin"]
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
        src = ["tag:infra-ci"]
        dst = ["tag:server"]
        ip  = ["tcp:22", "tcp:443"]
      },
      {
        src = ["tag:deploy"]
        dst = ["tag:server"]
        ip  = ["tcp:22"]
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
        src    = ["tag:infra-ci"]
        dst    = ["tag:server"]
        users  = ["root"]
      },
      {
        action = "accept"
        src    = ["tag:deploy"]
        dst    = ["tag:server"]
        users  = ["deploy"]
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
