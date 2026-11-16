variable "nameservers" {
  description = "DNS servers the tailnet uses for names outside MagicDNS."
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}
