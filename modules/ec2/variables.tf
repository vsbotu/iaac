variable "instances" {
  description = "MAP of ec2 instances , key ia instance Name and value is object with all properties"
  type = map(object({
    ami             = string
    instance_type   = string
    subnet_id       = string
    security_groups = optional(list(string), [])
    tags            = optional(map(string), {})
  }))
}

variable "key_name" {
  type = string
}
