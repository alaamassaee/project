########################################
# Creates a Listener for the ALB that attaches the frontent domain TLS Certificate
########################################

resource "aws_lb_listener" "frontent_tls" {
  load_balancer_arn = var.frontend_alb # Input the frontend ALB arn, for ARN existing in code correct VAR is "aws_lb.EXAMPLE_NAME.arn"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.frontent_cert # Input the already created frontent domain certificate ARN

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = var.content         # Proper content type for application (text/plain, text/html, etc...)
      status_code  = var.status_frontend # Status code for connection or redirection (200 is successful, 403 is denied access, etc...)
    }
  }
}

########################################
# Creates a Listener for the ALB that attaches the backend domain TLS Certificate
########################################

# resource "aws_lb_listener" "frontent_tls" {
#   load_balancer_arn = var.backend_alb # Input the backend ALB arn, for ARN existing in code correct VAR is "aws_lb.EXAMPLE_NAME.arn"
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"

#   certificate_arn = var.backend_cert # Input the already created backend domain certificate ARN

#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = var.content        # Proper content type for application (text/plain, text/html, etc...)
#       status_code  = var.status_backend # Status code for connection or redirection (200 is successful, 403 is denied access, etc...)
#     }
#   }
# }
