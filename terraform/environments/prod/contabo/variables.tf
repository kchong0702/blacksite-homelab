variable "hosts" {
  description = "VMs to run in this cloud, by tailnet hostname."
  type = map(object({
    size = string
  }))

  validation {
    condition     = alltrue([for host in values(var.hosts) : contains(["small", "medium"], host.size)])
    error_message = "size must be small or medium."
  }
}

variable "product_ids" {
  description = "Contabo product id per size, from `cntb get products`."
  type        = map(string)
}

variable "image_id" {
  description = "Ubuntu 24.04 image id from `cntb get images`."
  type        = string
}

variable "region" {
  type    = string
  default = "EU"
}
