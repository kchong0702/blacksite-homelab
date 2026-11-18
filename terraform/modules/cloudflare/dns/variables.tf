variable "zone_id" {
  description = "Zone the records are created in."
  type        = string
}

variable "records" {
  description = "Grey-cloud A records, hostname to IPv4."
  type        = map(string)
}
