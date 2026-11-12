variable "hostname" {
  type = string
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = list(string)
}

variable "harden_public_ip" {
  description = "Enable ufw and disable SSH password login, for hosts with a public IP and no cloud firewall."
  type        = bool
  default     = false
}
