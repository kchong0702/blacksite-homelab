variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data" {
  type      = string
  sensitive = true
}
