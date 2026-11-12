variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "ingress" {
  description = "Public hostname to origin service."
  type        = map(string)
}
