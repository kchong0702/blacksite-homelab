variable "hosts" {
  description = "VMs to run in this cloud, by tailnet hostname, with the subdomains that point at each one."
  type = map(object({
    size       = string
    subdomains = list(string)
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

variable "blueprint_id" {
  description = "Ubuntu 24.04 pure-OS blueprint ID from `tccli lighthouse DescribeBlueprints`."
  type        = string
}

variable "domain" {
  description = "Apex domain the host subdomains sit under."
  type        = string
  default     = "kelvinchong.dev"
}

variable "zone_id" {
  description = "ID of the Cloudflare zone for domain."
  type        = string
}
