variable "vpc_id" {
  type = string
}

/* This block is modified since the subnet id is unknown while executing the terraform plan, thus modifying the vars */
#variable "subnet_ids" {
#type = list(string)
#}
variable "subnets" {
  type = map(string)
}

variable "igw_name" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}