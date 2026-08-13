resource "aws_instance" "this" {

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}