variable "zone_id" {
  type = string
}

variable "records" {
  description = "Grey-cloud A records, hostname to IPv4."
  type        = map(string)
}
