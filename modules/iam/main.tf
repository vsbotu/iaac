resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_instance_profile ? 1 : 0

  name = var.role_name
  role = aws_iam_role.iam_role.name
}
