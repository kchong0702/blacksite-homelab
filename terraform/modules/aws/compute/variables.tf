variable "name" {
  description = "Name tag of the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type, such as t3.small."
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to the instance."
  type        = list(string)
}

variable "user_data" {
  description = "cloud-init config the instance runs on first boot."
  type        = string
  sensitive   = true
}
