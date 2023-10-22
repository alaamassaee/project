resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = var.ec2_type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  user_data              = file("/Users/khazar/Desktop/mini-project/reviews-app-23c-team6/bastion-server/script.tpl")
  tags = {
    Name = "bastion_host"
  }
}
# Security Groups ###########

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  vpc_id      = var.vpc_id
  description = "Allow authorized ssh"

  dynamic "ingress" {
    for_each = [22]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["67.87.37.117/32"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "rds_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}
