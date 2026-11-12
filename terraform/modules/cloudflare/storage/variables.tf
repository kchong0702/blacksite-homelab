variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "buckets" {
  type = map(object({
    public_domain = optional(string)
    cors_origins  = optional(list(string), [])
    cors_methods  = optional(list(string), [])
    cors_headers  = optional(list(string))
  }))
}
