data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 30
    encrypted   = true
  }

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}
