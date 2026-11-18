variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "Zone the tunnel's CNAME records are created in."
  type        = string
}

variable "name" {
  description = "Tunnel name."
  type        = string
}

variable "ingress" {
  description = "Public hostname to origin service."
  type        = map(string)
}
