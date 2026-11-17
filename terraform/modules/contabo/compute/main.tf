resource "contabo_instance" "this" {
  display_name = var.name
  product_id   = var.product_id
  image_id     = var.image_id
  region       = var.region
  period       = var.period
  user_data    = var.user_data

  lifecycle {
    ignore_changes = [user_data, image_id, ssh_keys]
  }
}

resource "contabo_firewall" "this" {
  name         = var.name
  status       = "active"
  instance_ids = [contabo_instance.this.id]

  rules {
    inbound {
      protocol   = "udp"
      action     = "accept"
      status     = "active"
      dest_ports = ["41641"]

      src_cidr {
        ipv4 = ["0.0.0.0/0"]
        ipv6 = ["::/0"]
      }
    }
  }
}
