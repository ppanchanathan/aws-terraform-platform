resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  /*
  tags = {
    Name = "platform-igw"
  }
*/

  tags = merge(
    {
      Name = var.igw_name
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = var.route_table_name
    },
    var.tags
  )
}

/*
resource "aws_route_table_association" "public" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.public.id
}
*/

resource "aws_route_table_association" "public" {
  #for_each       = toset(var.subnet_ids*)     # At plan time, Terraform doesn't yet know the values of: module.public_subents[*].subnet_id
  # Because the subnet haven't been created yet
  # Therefore:  toset(var.sbunet_ids*)
  for_each       = var.subnets
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}