resource "aws_security_group_rule" "opened_to_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.vpc_sg
  security_group_id        = aws_security_group.lt_sg.id
}

resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.frontend_ami
  instance_type = var.instance_type
  # vpc_security_group_ids = [var.vpc_sg]
  network_interfaces {
    subnet_id       = var.subnet_id
    security_groups = [aws_security_group.lt_sg.id]
  }
}

resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.backend_ami
  instance_type = var.instance_type
  # vpc_security_group_ids = [var.vpc_sg]
  network_interfaces {
    subnet_id       = var.subnet_id
    security_groups = [aws_security_group.lt_sg.id]
  }
}

resource "aws_security_group" "lt_sg" {
  name        = "lt-sg"
  vpc_id      = var.vpc_id
  description = "mini-project-launch template sg"

  # dynamic "ingress" {
  #   for_each = [22]

  #   content {
  #     from_port       = ingress.value
  #     to_port         = ingress.value
  #     protocol        = "tcp"
  #     security_groups = [aws_security_group_rule.opened_to_alb]
  #   }
  # }
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}
