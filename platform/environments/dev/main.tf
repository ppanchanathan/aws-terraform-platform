# Dev environment root module

module "vpc" {
  source = "../../modules/networking/vpc"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"
}
