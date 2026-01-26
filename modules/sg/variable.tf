variable "sg_name" {
  description = "name of security_groups"
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "VPC ID where the SG will be created"
}

variable "ingress_rules" {
  description = "Inbound rules for security_groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "outbound rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}