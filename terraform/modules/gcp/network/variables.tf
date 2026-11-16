variable "name" {
  description = "Name of the VPC and its subnet."
  type        = string
}

variable "region" {
  description = "Region of the subnet."
  type        = string
}

variable "ip_cidr_range" {
  description = "IPv4 range of the subnet."
  type        = string
  default     = "10.10.0.0/24"
}
