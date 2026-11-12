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
