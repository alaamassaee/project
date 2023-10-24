resource "aws_autoscaling_group" "asg" {
  name = var.name
  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = [var.subnet_ids]
  target_group_arns         = var.target_group_arns
  health_check_type         = "ELB"
  health_check_grace_period = 300
}

# Autoscaling Policy

resource "aws_autoscaling_policy" "CPU_scaling_policies" {
  name                      = "CPU_scaling_policies"
  autoscaling_group_name    = aws_autoscaling_group.asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 180

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}
