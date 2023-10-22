### provider
vpc_cidr         = "192.168.0.0/16"
pubsubnet1_cidr  = "192.168.1.0/24"
pubsubnet2_cidr  = "192.168.2.0/24"
privsubnet1_cidr = "192.168.3.0/24"
privsubnet2_cidr = "192.168.4.0/24"
name_tag         = "app"
### rds
username = "admin"
password = "admin123"
### s3
bucket_name = "project-bucket468343863285"
#### bastion_server
ec2_type = "t2.micro"
key_name = "second_key"
ami_id   = "ami-03eb6185d756497f8"
### alb
ssl_policy           = "ELBSecurityPolicy-2016-08"
cert_arn             = "arn:aws:acm:us-east-1:468343863285:certificate/7d036816-c5be-451a-abce-7ce161c70e2b"
zone_id              = "Z09993603VW1U51IAI9V"
alb_name             = "mini-project-alb"
alb_type             = "application"
alb_be_tg_name       = "backend-tg"
alb_fe_tg_name       = "frontend-tg"
protocol             = "HTTPS"
target_type          = "instance"
frontend_record      = "reviews"
backend_record       = "reviews-api"
ami_ids              = ["ami-0702e5d6cbb87c45b", "ami-08cd6cb2a1264f414"]
lt_name_prefix       = "launch_template"
desired_capacity     = 2
max_size             = 5
min_size             = 1
failover_bucket_name = "mini-project468343863285"
failover_record      = "failover"
