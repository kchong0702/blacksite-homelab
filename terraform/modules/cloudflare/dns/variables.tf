variable "tailnet_host" {
  description = "Tailnet hostname of the device the records point at."
  type        = string
}

variable "zone_id" {
  description = "Zone the records are created in."
  type        = string
}

variable "records" {
  description = "Fully qualified names of the grey-cloud A records."
  type        = list(string)
}
