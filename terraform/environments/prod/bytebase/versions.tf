terraform {
  required_version = ">= 1.11"

  cloud {
    workspaces {
      name = "prod-bytebase"
    }
  }

  required_providers {
    bytebase = {
      source  = "bytebase/bytebase"
      version = "3.24.0"
    }
  }
}
