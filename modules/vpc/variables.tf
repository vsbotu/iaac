variable "name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR  block for VPC"
}

variable "public_subnets" {
  description = "Value of Public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Private subnet"
  type        = map(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
