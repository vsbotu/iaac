module "vpc" {
  source = "../../modules/vpc"

  name            = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

module "ec2" {
  source   = "../../modules/ec2"
  key_name = var.key_name
  instances = {
    webserver1 = {
      ami             = var.ami_id
      instance_type   = "t3.micro"
      subnet_id       = module.vpc.public_subnet_ids[0]
      security_groups = [module.web_sg.sg_id]
      tags = {
        Role = "webserver"
      }
    }
    dbserver = {
      ami             = var.ami_id
      instance_type   = "t3.micro"
      subnet_id       = module.vpc.private_subnets_ids[0]
      security_groups = [module.dbserver_sg.sg_id]
      tags = {
        Role = "DBserver"
      }
    }
  }
}



# Web server SG
module "web_sg" {
  source  = "../../modules/sg"
  sg_name = "webserver-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    }
  ]
}


# Web server SG
module "dbserver_sg" {
  source  = "../../modules/sg"
  sg_name = "dbserver-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    }
  ]
}
