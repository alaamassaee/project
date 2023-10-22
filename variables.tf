variable "vpc_cidr" {
  type = string
}

variable "name_tag" {
  type = string
}

variable "pubsubnet1_cidr" {
  type = string
}

variable "pubsubnet2_cidr" {
  type = string
}

variable "privsubnet1_cidr" {
  type = string
}

variable "privsubnet2_cidr" {
  type = string
}
#### rds
variable "username" {
  type = string
}

variable "password" {
  type = string
}
###### s3
variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
}
#### bastion host
variable "ami_id" {
  type = string
}
variable "ec2_type" {
  type = string
}
variable "key_name" {
  type = string
}
##### alb 
variable "alb_name" {
  type = string
}
variable "alb_type" {
  type = string
}
variable "alb_be_tg_name" {
  type = string
}
variable "alb_fe_tg_name" {
  type = string
}
variable "protocol" {
  type = string
}
variable "target_type" {
  type = string
}
variable "ssl_policy" {
  type = string
}
variable "cert_arn" {
  type = string
}
variable "zone_id" {
  type = string
}
variable "frontend_record" {
  type = string
}
variable "backend_record" {
  type = string
}
variable "failover_record" {

}

### asg variables 
# variable "frontend_ami" {}

# variable "backend_ami" {}

# variable "lt_name_prefix" {}

# variable "instance_type" {}

variable "desired_capacity" {}

variable "max_size" {}

variable "min_size" {}

# variable "subnet_ids" {}

# variable "frontend_launch_template" {}

# variable "backend_launch_template" {}

# variable "target_group_arns" {}

variable "ami_ids" {
  type = list(string)
}
#### lt
variable "lt_name_prefix" {
  type = string
}
# variable "frontend_ami" {
#   type = string
# }
# variable "instance_type" {
#   type = string
# }
# variable "backend_ami" {
#   type = string
# }
variable "failover_bucket_name" {
  description = "s3 bucket name"
  type        = string
}
