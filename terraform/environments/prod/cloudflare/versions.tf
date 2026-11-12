terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "prod-cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.29.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.3"
    }
  }
}
