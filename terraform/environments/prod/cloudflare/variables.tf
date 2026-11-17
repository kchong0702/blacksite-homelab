variable "domain" {
  description = "Apex domain of the zone."
  type        = string
  default     = "kelvinchong.dev"
}

variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "ID of the zone for domain."
  type        = string
}

variable "ezbot_subdomain" {
  description = "Public subdomain for ezbot, served through the tunnel."
  type        = string
  default     = "ezbot"
}

variable "ops_subdomain" {
  description = "Tailnet-only subdomain for ops-web."
  type        = string
  default     = "ops"
}

variable "bytebase_subdomain" {
  description = "Tailnet-only subdomain for Bytebase."
  type        = string
  default     = "bytebase"
}

variable "assets_subdomain" {
  description = "Public subdomain for the portfolio R2 bucket."
  type        = string
  default     = "assets"
}

variable "tailnet_host" {
  description = "Tailnet hostname of the VM, also used as the tunnel name."
  type        = string
  default     = "blacksite"
}
