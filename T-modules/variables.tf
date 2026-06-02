variable "name"                { type = string }
variable "aws_region"          { type = string }
variable "vpc_cidr"            { type = string }
variable "public_subnet_cidr"  { type = string }
variable "private_subnet_cidr" { type = string }
variable "az"                  { type = string }
variable "ami"                 { type = string }
variable "instance_type"       { type = string }
variable "key_path"            { type = string }
variable "private_subnet2_cidr" {
  type = string
}

variable "az2" {
  type = string
}