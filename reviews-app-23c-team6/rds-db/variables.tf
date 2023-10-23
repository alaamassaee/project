variable "username" {
  type = string
}

variable "password" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "bastion_host_sg" {
  type = list(string)
}
