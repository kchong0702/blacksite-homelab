terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.73.0"
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
