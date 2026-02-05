data "aws_caller_identity" "current" {}
#eks Cluster
resource "aws_eks_cluster" "eks" {
  name     = "${var.eks_name}-cluster"
  role_arn = var.cluster_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"] # Restrict in production
    security_group_ids      = var.cluster_security_group_ids
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  tags = {
    Name = var.eks_name
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.eks_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = ["t3.medium"]
  ami_type       = var.ami_type

  remote_access {
    ec2_ssh_key               = "iaac" # your keypair
    source_security_group_ids = var.worker_security_group_ids
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.eks
  ]
}

resource "aws_eks_access_entry" "root_user" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

resource "aws_eks_access_policy_association" "root_user_admin" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_eks_access_entry.root_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
