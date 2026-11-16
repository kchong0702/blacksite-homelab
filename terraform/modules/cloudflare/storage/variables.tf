variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "Zone for the buckets' public custom domains."
  type        = string
}

variable "buckets" {
  description = "R2 buckets by name. public_domain serves a bucket publicly on that hostname. A CORS rule is added only when cors_origins is set."
  type = map(object({
    public_domain = optional(string)
    cors_origins  = optional(list(string), [])
    cors_methods  = optional(list(string), [])
    cors_headers  = optional(list(string))
  }))
}
