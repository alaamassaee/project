resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 443]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = var.alb_type
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
  subnets                    = [var.alb_subnet_1, var.alb_subnet_2]
}

resource "aws_lb_target_group" "frontend_target_group" {
  name        = var.alb_be_tg_name
  port        = 443
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "backend_target_group" {
  name        = var.alb_fe_tg_name
  port        = 443
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 443
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

# resource "aws_instance" "frontend_instances" {
#   count         = 2              # Change this to the desired number of instances
#   ami           = "ami-xxxxxxxx" # Replace with your AMI ID
#   instance_type = "t2.micro"     # Replace with your desired instance type
#   # Configure instance details as needed
# }

# resource "aws_instance" "backend_instances" {
#   count         = 2              # Change this to the desired number of instances
#   ami           = "ami-yyyyyyyy" # Replace with your AMI ID
#   instance_type = "t2.micro"     # Replace with your desired instance type
#   # Configure instance details as needed
# }

# resource "aws_lb_target_group_attachment" "frontend_attachment" {
#   # count            = length(aws_instance.frontend_instances)
#   target_group_arn = aws_lb_target_group.frontend_target_group.arn
#   target_id        = aws_instance.frontend_instances[count.index].id
# }


# resource "aws_lb_target_group_attachment" "backend_attachment" {
#   # count            = length(aws_instance.frontend_instances)
#   target_group_arn = aws_lb_target_group.backend_target_group.arn
#   target_id        = aws_instance.backend_instances[count.index].id
# }

resource "aws_route53_record" "frontend_record" {
  zone_id = var.zone_id
  name    = var.frontend_record
  ttl     = 300
  type    = "CNAME"
  records = [aws_lb.my_alb.dns_name]

}

resource "aws_route53_record" "backend_record" {
  zone_id = var.zone_id
  name    = var.backend_record
  ttl     = 300
  type    = "CNAME"
  records = [aws_lb.my_alb.dns_name]
}

resource "aws_route53_record" "failover_record" {
  zone_id = var.zone_id
  name    = var.failover_record
  type    = "CNAME"

  failover_routing_policy {
    type = "PRIMARY"
  }
  set_identifier = "primary"
  # records        = [aws_lb.my_alb.dns_name]
  alias {
    name                   = aws_lb.my_alb.dns_name
    zone_id                = aws_lb.my_alb.zone_id
    evaluate_target_health = true
  }
}



