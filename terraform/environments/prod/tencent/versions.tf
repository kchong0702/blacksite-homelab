terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "prod-tencent"
    }
  }

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.83.42"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.3"
    }
  }
}
