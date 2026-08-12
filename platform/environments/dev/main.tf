# Dev environment root module

module "vpc" {
  source = "../../modules/networking/vpc"

  name = local.names.vpc
  cidr = "10.10.0.0/16"

  tags = local.common_tags
}

/*
module "public_subnets" {
  for_each = local.public_subnets
  
  source = "../../modules/networking/subnets"
  
  name = "platform-dev-${each.key}"
  cidr = each.value
  vpc_id = module.vpc.vpc_id

  map_public_ip_on_launch = true

  tags = local.common_tags
}
*/

module "public_subnets" {

  for_each = local.public_subnets

  source = "../../modules/networking/subnets"

  name              = each.value.name
  cidr              = each.value.cidr
  availability_zone = each.value.az
  vpc_id            = module.vpc.vpc_id

  map_public_ip_on_launch = true

  tags = local.common_tags
}

#
# Routing
#
module "routing" {

  source = "../../modules/networking/routing"

  vpc_id = module.vpc.vpc_id

  subnets = {
    for subnet_name, subnet_module in module.public_subnets :
    subnet_name => subnet_module.subnet_id
  }

  igw_name         = local.names.igw
  route_table_name = local.names.route_table

  tags = local.common_tags
}

/*
module "routing" {

  source = "../../modules/networking/routing"

  vpc_id = module.vpc.vpc_id


Terraform cannot use subnet IDs directly in for_each because
the IDs are not known until apply time.
Using a map with static keys (public-a, public-b, public-c)
allows Terraform to determine resource instances during planning.



  subnet_ids = [
    for subnet in module.public_subnets :
    subnet.subnet_id
  ]

  igw_name         = local.names.igw
  route_table_name = local.names.route_table

  tags = local.common_tags
}
*/

/*
#
# Public Subnet A
#
module "subnet_public_a" {
  source = "../../modules/networking/subnets"

  name = "platform-dev-public-a"
  cidr = "10.10.1.0/24"
  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}

#
# Public Subnet B
#
module "subnet_public_b" {
  source = "../../modules/networking/subnets"

  name = "platform-dev-public-b"
  cidr = "10.10.2.0/24"
  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}

#
# Public Subnet C
#
module "subnet_public_c" {
  source = "../../modules/networking/subnets"

  name = "platform-dev-public-c"
  cidr = "10.10.3.0/24"
  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}
*/

