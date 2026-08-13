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

    security_group = "${local.project}-${local.environment}-sg"
    ec2            = "${local.project}-${local.environment}-ec2"
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

  compute = {
    subnet        = "public-a"
    instance_type = "t3.micro"

    ssh_cidr         = "0.0.0.0/0"
    root_volume_size = 40
    root_volume_type = "gp3"
  }

  security_group = {
    ingress_rules = [

      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        #cidr_blocks = ["0.0.0.0/0"]
        cidr_blocks = [local.compute.ssh_cidr]
      },

      {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        #cidr_blocks = ["0.0.0.0/0"]
        cidr_blocks = [local.compute.ssh_cidr]
      },

      {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        #cidr_blocks = ["0.0.0.0/0"]
        cidr_blocks = [local.compute.ssh_cidr]
      }
    ]
  }
}

/*
locals {

  security_group = {
    ingress_rules = [

      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },

      {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },

      {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

*/
