variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "Zone that holds the CNAME records for domains."
  type        = string
}

variable "name" {
  description = "Pages project name."
  type        = string
}

variable "production_branch" {
  description = "Branch that Pages deploys as production."
  type        = string
  default     = "main"
}

variable "domains" {
  description = "Custom domains for the project. Each gets a CNAME record in the zone."
  type        = list(string)
}
