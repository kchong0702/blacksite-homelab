variable "name" {
  description = "Name of the network and subnetwork."
  type        = string
}

variable "region" {
  type = string
}

variable "ip_cidr_range" {
  type    = string
  default = "10.10.0.0/24"
}
