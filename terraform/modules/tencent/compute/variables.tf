variable "name" {
  description = "Display name of the instance."
  type        = string
}

variable "bundle_id" {
  description = "Lighthouse bundle ID, which sets the VM size."
  type        = string
}

variable "blueprint_id" {
  description = "Ubuntu 24.04 blueprint ID from `tccli lighthouse DescribeBlueprints`."
  type        = string
}

variable "firewall_template_id" {
  description = "Firewall template the instance is created with."
  type        = string
}

variable "period" {
  description = "Subscription period in months."
  type        = number
  default     = 1
}

variable "bootstrap_script" {
  description = "Shell script the instance runs once through TencentCloud Automation Tools after it starts."
  type        = string
  sensitive   = true
}
