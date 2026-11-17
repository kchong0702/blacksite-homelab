resource "tencentcloud_lighthouse_instance" "this" {
  instance_name        = var.name
  bundle_id            = var.bundle_id
  blueprint_id         = var.blueprint_id
  period               = var.period
  renew_flag           = "NOTIFY_AND_AUTO_RENEW"
  firewall_template_id = var.firewall_template_id

  lifecycle {
    ignore_changes = [blueprint_id]
  }
}

resource "tencentcloud_tat_invocation_command_attachment" "bootstrap" {
  instance_id  = tencentcloud_lighthouse_instance.this.id
  command_name = "bootstrap"
  content      = base64encode(var.bootstrap_script)
  timeout      = 600

  lifecycle {
    ignore_changes = [content]
  }
}
