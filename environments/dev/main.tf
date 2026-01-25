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
      ami           = var.ami_id
      instance_type = "t3.micro"
      subnet_id     = module.vpc.public_subnet_ids[0]
      tags = {
        Role = "webserver"
      }
    }
    dbserver = {
      ami           = var.ami_id
      instance_type = "t3.micro"
      subnet_id     = module.vpc.private_subnets_ids[0]
      tags = {
        Role = "DBserver"
      }
    }
  }
}