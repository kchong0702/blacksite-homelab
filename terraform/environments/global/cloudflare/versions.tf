terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "global-cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.29.0"
    }
  }
}
