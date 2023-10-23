output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend_target_group.arn
}
output "backend_tg_arn" {
  value = aws_lb_target_group.backend_target_group.arn
}
output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
