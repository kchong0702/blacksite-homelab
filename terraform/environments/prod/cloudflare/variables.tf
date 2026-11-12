variable "domain" {
  type    = string
  default = "kelvinchong.dev"
}

variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "ezbot_subdomain" {
  type    = string
  default = "ezbot"
}

variable "ops_subdomain" {
  type    = string
  default = "ops"
}

variable "bytebase_subdomain" {
  type    = string
  default = "bytebase"
}

variable "assets_subdomain" {
  type    = string
  default = "assets"
}

variable "tailnet_host" {
  description = "Tailnet hostname of the VM the grey-cloud records point at."
  type        = string
  default     = "blacksite"
}
