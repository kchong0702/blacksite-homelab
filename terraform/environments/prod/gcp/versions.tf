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
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.3"
    }
  }
}
