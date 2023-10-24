variable "vpc_id" {
  type = string
}
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
variable "alb_subnet_2" {
  type = string
}
variable "alb_subnet_1" {
  type = string
}
variable "failover_record" {
  type = string
}
variable "listner_protocol" {
  type = string
}
