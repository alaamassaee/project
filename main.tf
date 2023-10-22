module "app_vpc" {
  source           = "./reviews-app-23c-team6/networking"
  vpc_cidr         = var.vpc_cidr
  pubsubnet1_cidr  = var.pubsubnet1_cidr
  pubsubnet2_cidr  = var.pubsubnet2_cidr
  privsubnet1_cidr = var.privsubnet1_cidr
  privsubnet2_cidr = var.privsubnet2_cidr
  name_tag         = var.name_tag
}
module "rds" {
  source   = "./reviews-app-23c-team6/rds-db"
  username = var.username
  password = var.password
}
module "bastion_host" {
  source    = "./reviews-app-23c-team6/bastion-server"
  ami_id    = var.ami_id
  ec2_type  = var.ec2_type
  key_name  = var.key_name
  subnet_id = module.app_vpc.public_subnet1_id
  vpc_id    = module.app_vpc.vpc_id
}
module "alb" {
  source          = "./reviews-app-23c-team6/alb"
  vpc_id          = module.app_vpc.vpc_id
  alb_name        = var.alb_name
  alb_type        = var.alb_type
  alb_be_tg_name  = var.alb_be_tg_name
  alb_fe_tg_name  = var.alb_fe_tg_name
  protocol        = var.protocol
  target_type     = var.target_type
  ssl_policy      = var.ssl_policy
  cert_arn        = var.cert_arn
  zone_id         = var.zone_id
  frontend_record = var.frontend_record
  backend_record  = var.backend_record
  alb_subnet_1    = module.app_vpc.public_subnet1_id
  alb_subnet_2    = module.app_vpc.public_subnet2_id
  failover_record = var.failover_record

}

module "lt" {
  source         = "./reviews-app-23c-team6/lt"
  instance_type  = var.ec2_type
  lt_name_prefix = var.lt_name_prefix
  frontend_ami   = var.ami_ids[0]
  backend_ami    = var.ami_ids[1]

}

module "asg" {
  source                   = "./reviews-app-23c-team6/asg"
  frontend_ami             = var.ami_ids[0]
  backend_ami              = var.ami_ids[1]
  instance_type            = var.ec2_type
  subnet_ids               = module.app_vpc.public_subnet1_id
  lt_name_prefix           = var.lt_name_prefix
  desired_capacity         = var.desired_capacity
  max_size                 = var.max_size
  min_size                 = var.min_size
  frontend_launch_template = module.lt.frontend_launch_template_id
  backend_launch_template  = module.lt.backend_launch_template_id
  target_group_arns        = module.alb.frontend_tg_arn


}

# module "asg_backend" {
#   source                  = "./reviews-app-23c-team6/asg"
#   instance_type           = var.ec2_type
#   image_id                = var.ami_ids[1]
#   subnet_ids              = module.app_vpc.public_subnet2_id
#   lt_name_prefix          = var.lt_name_prefix
#   desired_capacity        = var.desired_capacity
#   max_size                = var.max_size
#   min_size                = var.min_size
#   backend_launch_template = module.lt-frontend.backend_launch_template_id
#   target_group_arns       = module.alb.backend_tg_arn
# }
module "s3_module" {
  source               = "./reviews-app-23c-team6/s3"
  failover_bucket_name = var.failover_bucket_name
}
