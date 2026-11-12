variable "name" {
  description = "Instance name."
  type        = string
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data" {
  description = "Rendered cloud-init."
  type        = string
  sensitive   = true
}
