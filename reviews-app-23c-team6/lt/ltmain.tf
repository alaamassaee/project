resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.frontend_ami
  instance_type = var.instance_type
}

resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = var.lt_name_prefix
  image_id      = var.backend_ami
  instance_type = var.instance_type
}
