module "vpc" {
  source = "../../modules/networking/vpc"

  name = local.names.vpc
  cidr = "10.20.0.0/16"

  tags = local.common_tags
}

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

module "eks" {
  source = "../../modules/kubernetes/eks"

  name = local.names.eks

  kubernetes_version = local.eks.version

  access_principals = local.eks.access_principals

  subnet_ids = [
    for subnet in module.public_subnets :
    subnet.subnet_id
  ]

  tags = local.common_tags
}

module "node_group" {
  source = "../../modules/kubernetes/nodegroups"

  name = local.names.node_group

  cluster_name = module.eks.cluster_name

  subnet_ids = [
    for subnet in module.public_subnets :
    subnet.subnet_id
  ]

  instance_types = local.node_group.instance_types
  desired_size   = local.node_group.desired_size
  min_size       = local.node_group.min_size
  max_size       = local.node_group.max_size

  tags = local.common_tags
}