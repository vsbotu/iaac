variable "role_name" {
  type        = string
  description = "IAM role name"
}
variable "assume_role_policy" {
  type        = string
  description = "Trust policy: who can assume this role"
}

variable "policy_arns" {
  type        = list(string)
  description = "Permissions attached to the role"
  default     = []
}

variable "create_instance_profile" {
  type        = bool
  description = "Create instance profile (needed only for EC2)"
  default     = false
}