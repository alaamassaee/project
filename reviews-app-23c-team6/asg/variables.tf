variable "lt_name_prefix" {}

variable "instance_type" {}

variable "desired_capacity" {}

variable "max_size" {}

variable "min_size" {}

variable "subnet_ids" {}

variable "launch_template" {}

variable "target_group_arns" {
  type = list(string)
}

variable "name" {
  type = string
}
