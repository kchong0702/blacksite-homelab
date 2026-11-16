variable "nameservers" {
  description = "DNS servers the tailnet uses for names outside MagicDNS."
  type        = list(string)
}
