module "vpc" {
    source = "../../modules/vpc"
    name = var.vpc_name
    cluster_name    = "iaac-eks"
    vpc_cidr = var.vpc_cidr
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
}


module "eks_cluster_sg" {
  source  = "../../modules/sg"
  sg_name = "${var.vpc_name}-eks-cluster-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # later restrict to office IP
      description = "Kubernetes API access"
    }
  ]
}

module "iam_eks_cluster" {
  source    = "../../modules/iam"
  role_name = "${var.vpc_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}


module "iam_eks_nodes" {
  source    = "../../modules/iam"
  role_name = "${var.vpc_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}
