provider "aws" {
  region = var.region
}

provider "cloudflare" {}

provider "tailscale" {}
