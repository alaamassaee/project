output "autoscaling_group_id" {
  description = "Autoscaling Group ID"
  value       = aws_autoscaling_group.asg.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}
