terraform {
  required_version = ">= 1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.11.0"
    }
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
