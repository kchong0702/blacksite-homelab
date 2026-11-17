resource "tencentcloud_lighthouse_firewall_template" "this" {
  template_name = var.name

  template_rules {
    protocol                  = "UDP"
    port                      = "41641"
    cidr_block                = "0.0.0.0/0"
    action                    = "ACCEPT"
    firewall_rule_description = "Tailscale direct connections"
  }
}
