variable "eks_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for EKS"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for worker nodes"
  type        = string
}

variable "cluster_security_group_ids" {
  description = "Security groups attached to cluster ENIs"
  type        = list(string)
}

variable "worker_security_group_ids" {
  description = "Security group allowed to SSH into worker nodes"
  type        = list(string)
}

variable "node_desired_size" { type = number }
variable "node_min_size"     { type = number }
variable "node_max_size"     { type = number }

variable "ami_type" {
  description = "AMI type for EKS nodes"
  type        = string
}
