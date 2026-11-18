terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "prod-gcp"
    }
  }

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
      version = "0.30.0"
    }
  }
}
