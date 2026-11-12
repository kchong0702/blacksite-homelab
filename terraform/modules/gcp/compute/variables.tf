variable "name" {
  description = "Instance name."
  type        = string
}

variable "machine_type" {
  type = string
}

variable "zone" {
  type = string
}

variable "subnetwork_id" {
  type = string
}

variable "user_data" {
  description = "Rendered cloud-init."
  type        = string
  sensitive   = true
}
