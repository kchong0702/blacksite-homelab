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

variable "region" {
  type = string
}
