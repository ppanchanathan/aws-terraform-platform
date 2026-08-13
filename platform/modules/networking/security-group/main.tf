/*
resource "aws_security_group" "this" {

  name        = var.name
  description = "Security group managed by Terraform"

  vpc_id = var.vpc_id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

*/


resource "aws_security_group" "this" {

  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {

    for_each = var.ingress_rules

    content {

      description = ingress.value.description

      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port

      protocol = ingress.value.protocol

      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

