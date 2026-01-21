variable "name" {
    description = "VPC name"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR  block for VPC"
}

variable "public_subnets" {
  description = "Value of Public subnets"
  type = map(string)
}
