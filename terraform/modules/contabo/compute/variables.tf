variable "name" {
  description = "Display name of the instance."
  type        = string
}

variable "product_id" {
  description = "Contabo product ID, which sets the VM size."
  type        = string
}

variable "image_id" {
  description = "Ubuntu 24.04 image id from `cntb get images`."
  type        = string
}

variable "region" {
  description = "Contabo region for the instance."
  type        = string
  default     = "EU"
}

variable "period" {
  description = "Contract period in months: 1, 3, 6 or 12."
  type        = number
  default     = 1
}

variable "user_data" {
  description = "cloud-init config the instance runs on first boot."
  type        = string
  sensitive   = true
}
