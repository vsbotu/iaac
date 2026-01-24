variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = map(string)
}