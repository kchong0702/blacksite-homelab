terraform {
  required_version = ">= 1.11"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.83.42"
    }
  }
}
