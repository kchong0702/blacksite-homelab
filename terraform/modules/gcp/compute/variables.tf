variable "name" {
  description = "Name of the instance."
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type, such as e2-small."
  type        = string
}

variable "zone" {
  description = "Zone the instance runs in."
  type        = string
}

variable "subnetwork_id" {
  description = "Subnet the instance attaches to."
  type        = string
}

variable "user_data" {
  description = "cloud-init config the instance runs on first boot."
  type        = string
  sensitive   = true
}
