/*
locals {

  common_tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "aws-terraform-platform"
    Owner       = "Pasupathi"
  }

  public_subnets = {
    public-a = "10.10.1.0/24"
    public-b = "10.10.2.0/24"
    public-c = "10.10.3.0/24"
  }
}
*/

locals {

  environment = "dev"

  project = "platform"

  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = local.project
    Owner       = "Pasupathi"
  }

  names = {
    vpc         = "${local.project}-${local.environment}-vpc"
    igw         = "${local.project}-${local.environment}-igw"
    route_table = "${local.project}-${local.environment}-public-rt"
  }

  public_subnets = {

    public-a = {
      cidr = "10.10.1.0/24"
      az   = "us-east-2a"
      name = "${local.project}-${local.environment}-public-a"
    }

    public-b = {
      cidr = "10.10.2.0/24"
      az   = "us-east-2b"
      name = "${local.project}-${local.environment}-public-b"
    }

    public-c = {
      cidr = "10.10.3.0/24"
      az   = "us-east-2c"
      name = "${local.project}-${local.environment}-public-c"
    }
  }
}
