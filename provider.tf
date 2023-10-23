# terraform {
#   backend "s3" {
#     bucket         = "project-backend468343863285"
#     key            = "terraform/tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock"
#     encrypt        = true
#   }
# }
# resource "aws_dynamodb_table" "terraform_lock" {
#   name           = "terraform-lock"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"
#   read_capacity  = 1
#   write_capacity = 1
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.17.0"
#     }
#   }
# }

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
