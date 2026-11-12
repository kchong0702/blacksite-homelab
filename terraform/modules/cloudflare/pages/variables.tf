variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "production_branch" {
  type    = string
  default = "main"
}

variable "domains" {
  type = list(string)
}
