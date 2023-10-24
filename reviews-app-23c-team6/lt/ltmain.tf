resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.frontend_ami
  instance_type = var.instance_type
  network_interfaces {
    subnet_id       = var.subnet_id
    security_groups = [aws_security_group.lt_sg.id]
  }
}

resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.backend_ami
  instance_type = var.instance_type
  # iam_instance_profile {
  #   name = aws_iam_role.read_secret.name
  # }
  network_interfaces {
    subnet_id       = var.subnet_id
    security_groups = [aws_security_group.lt_sg.id]
  }
}

resource "aws_security_group" "lt_sg" {
  name        = "lt-sg"
  vpc_id      = var.vpc_id
  description = "mini-project-launch template sg"

  dynamic "ingress" {
    for_each = [80, 443]

    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = var.open_to_elb_sg
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "aws_iam_role" "read_secret" {
#   name = "read-secert"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
# resource "aws_iam_policy_attachment" "policy_attachment" {
#   name       = "example-policy-attachment"
#   policy_arn = "arn:aws:iam::468343863285:policy/SecretManagerReadOnly"
#   roles      = [aws_iam_role.read_secret.name]
# }
