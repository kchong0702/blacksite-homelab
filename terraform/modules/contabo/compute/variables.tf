variable "name" {
  type = string
}

variable "product_id" {
  type = string
}

variable "image_id" {
  description = "Ubuntu 24.04 image id from `cntb get images`."
  type        = string
}

variable "region" {
  type    = string
  default = "EU"
}

variable "period" {
  description = "Contract period in months: 1, 3, 6 or 12."
  type        = number
  default     = 1
}

variable "user_data" {
  type      = string
  sensitive = true
}
