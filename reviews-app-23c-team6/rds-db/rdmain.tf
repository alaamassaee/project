
# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.bastion_host_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database security group"
  }
}


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database subnet id"
  subnet_ids  = var.subnet_ids
  description = "subnets for database instance"

  tags = {
    Name = "database subnets"
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = "mysql"
  engine_version         = "5.7"
  multi_az               = false
  identifier             = "mini-project-rds"
  username               = var.username
  password               = var.password
  instance_class         = "db.t3.micro"
  storage_type           = "gp2"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  # availability_zone      = data.aws_availability_zones.available_zones.names[0]
  db_name             = "project"
  skip_final_snapshot = true
}
