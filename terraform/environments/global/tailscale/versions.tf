terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "global-tailscale"
    }
  }

  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.3"
    }
  }
}
