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
  description = "Tencent Cloud region for the VMs."
  type        = string
}

variable "bundle_ids" {
  description = "Lighthouse bundle ID per size, from `tccli lighthouse DescribeBundles`."
  type        = map(string)
}

variable "blueprint_id" {
  description = "Ubuntu 24.04 blueprint ID from `tccli lighthouse DescribeBlueprints`."
  type        = string
}
