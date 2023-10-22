output "frontend_launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.frontend_launch_template.id
}
output "backend_launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.backend_launch_template.id
}
