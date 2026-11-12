terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "prod-contabo"
    }
  }

  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = "0.1.44"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.3"
    }
  }
}
