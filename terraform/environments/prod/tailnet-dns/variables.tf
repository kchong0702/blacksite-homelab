variable "domain" {
  description = "Apex domain of the zone."
  type        = string
  default     = "kelvinchong.dev"
}

variable "zone_id" {
  description = "ID of the zone for domain."
  type        = string
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

variable "tailnet_host" {
  description = "Tailnet hostname of the VM the grey-cloud records point at."
  type        = string
  default     = "blacksite"
}
