output "sg_id" {
  value       = aws_security_group.sg.id
  description = "The ID of the security group"
}

output "sg_name" {
  value       = aws_security_group.sg.name
  description = "The name of the security group"
}
