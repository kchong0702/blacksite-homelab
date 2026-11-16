variable "hostname" {
  description = "Hostname the VM joins the tailnet with."
  type        = string
}

variable "tailscale_auth_key" {
  description = "Single-use auth key that joins the VM to the tailnet."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tailscale tags the VM advertises, such as tag:server."
  type        = list(string)
}

variable "harden_public_ip" {
  description = "Enable ufw and disable SSH password login, for hosts with a public IP and no cloud firewall."
  type        = bool
  default     = false
}
