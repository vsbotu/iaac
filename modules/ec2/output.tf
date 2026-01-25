output "instance_id" {
  description = "list of instance id"
  value       = [for i in aws_instance.instance : i.id]
}

output "private_ip" {
  description = "private_ip of instance"
  value       = [for i in aws_instance.instance : i.private_ip]
}

output "public_ips" {
  description = "Public IP of all instances"
  value       = [for i in aws_instance.instance : i.public_ip]
}