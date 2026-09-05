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
module "security_group" {

  source = "../../modules/networking/security-group"

  name = local.names.security_group

  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}
*/

module "security_group" {

  source = "../../modules/networking/security-group"

  name = local.names.security_group

  vpc_id = module.vpc.vpc_id

  ingress_rules = local.security_group.ingress_rules

  tags = local.common_tags
}

module "ec2" {

  source = "../../modules/compute/ec2"

  name = local.names.ec2

  #ami_id = data.aws_ami.amazon_linux.id
  ami_id = local.compute.ami_id

  #instance_type = "t3.micro"
  instance_type = local.compute.instance_type

  #subnet_id = module.public_subnets["public-a"].subnet_id
  subnet_id = module.public_subnets[
    local.compute.subnet
  ].subnet_id

  security_group_ids = [
    module.security_group.security_group_id
  ]

  root_volume_size = local.compute.root_volume_size
  root_volume_type = local.compute.root_volume_type

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


# =================

module "ecr" {

  source = "../../modules/containers/ecr"

  name = local.names.ecr

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

  desired_size = local.node_group.desired_size

  min_size = local.node_group.min_size

  max_size = local.node_group.max_size

  tags = local.common_tags
}


module "irsa" {

  source = "../../modules/kubernetes/irsa"

  role_name            = local.irsa.role_name
  namespace            = local.irsa.namespace
  service_account_name = local.irsa.service_account_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_issuer_url      = module.eks.oidc_issuer_url
  policy_arns          = local.irsa.policy_arns

  tags = local.common_tags
}

module "alb_controller" {

  source = "../../modules/kubernetes/alb-controller"

  namespace            = local.alb_controller.namespace
  service_account_name = local.alb_controller.service_account_name
  role_name            = local.alb_controller.role_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_issuer_url      = module.eks.oidc_issuer_url
  tags                 = local.common_tags
}

module "external_secrets" {
  source = "../../modules/kubernetes/external-secrets"

  role_name            = local.external_secrets.role_name
  namespace            = local.external_secrets.namespace
  service_account_name = local.external_secrets.service_account_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_issuer_url      = module.eks.oidc_issuer_url

  secret_arns = ["arn:aws:secretsmanager:us-east-2:240815058507:secret:platform/dev/*"]

  tags = local.common_tags
}

module "cloudwatch_exporter" {
  source = "../../modules/kubernetes/cloudwatch-exporter"

  role_name            = local.cloudwatch_exporter.role_name
  namespace            = local.cloudwatch_exporter.namespace
  service_account_name = local.cloudwatch_exporter.service_account_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_issuer_url      = module.eks.oidc_issuer_url

  tags = local.common_tags
}