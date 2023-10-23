#Creating Autoscaling group

# resource "aws_autoscaling_group" "asg" {
#   name                = "Autoscaling"
#   capacity_rebalance  = true
#   desired_capacity    = var.desired_capacity
#   max_size            = var.max_size
#   min_size            = var.min_size
#   vpc_zone_identifier = [var.subnet_ids]
#   target_group_arns   = [var.target_group_arns]
#   # Mixed
#   mixed_instances_policy {
#     launch_template {
#       launch_template_specification {
#         launch_template_id = var.frontend_launch_template
#       }
#       override {
#         instance_type = "t2.micro"
#       }

#       override {
#         instance_type = "t3.micro"
#         launch_template_specification {
#           launch_template_id = var.backend_launch_template

#         }
#       }x
#     }
#   }
# }
resource "aws_autoscaling_group" "asg" {
  name = var.name
  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 5
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
