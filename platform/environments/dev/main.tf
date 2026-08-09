# Dev environment root module

module "vpc" {
  source = "../../modules/networking/vpc"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"
}

module "subnet" {
  source = "../../modules/networking/subnets"

  name   = "public-subnet"
  cidr   = "10.0.1.0/24"
  vpc_id = module.vpc.vpc_id
}

module "routing" {
  source = "../../modules/networking/routing"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.subnet.public_subnet_id
}