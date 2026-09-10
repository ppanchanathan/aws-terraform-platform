locals {
  environment = "staging"
  project     = "platform"

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

    eks        = "${local.project}-${local.environment}-eks"
    node_group = "${local.project}-${local.environment}-ng"
  }

  public_subnets = {
    public-a = {
      cidr = "10.20.1.0/24"
      az   = "us-west-2a"
      name = "${local.project}-${local.environment}-public-a"
    }
    public-b = {
      cidr = "10.20.2.0/24"
      az   = "us-west-2b"
      name = "${local.project}-${local.environment}-public-b"
    }
  }

  eks = {
    version = "1.34"

    access_principals = {
      cluster_admins = [
        "arn:aws:iam::240815058507:root"
      ]
    }
  }

  node_group = {
    instance_types = ["m7i-flex.large"]
    desired_size   = 2
    min_size       = 0
    max_size       = 2
  }
}