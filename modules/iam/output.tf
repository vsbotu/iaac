output "role_name" {
  value = aws_iam_role.iam_role.name
}

output "role_arn" {
  value = aws_iam_role.iam_role.arn
}

output "instance_profile_name" {
  value = try(aws_iam_instance_profile.ec2_instance_profile[0].name, null)
}