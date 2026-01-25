resource "aws_instance" "instance" {
  for_each      = var.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  key_name      = var.key_name
  # Attach security groups
  vpc_security_group_ids = each.value.security_groups
  tags = merge(each.value.tags,
    {
      Name = each.key
    }
  )
}